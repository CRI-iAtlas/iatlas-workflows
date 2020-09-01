#!/usr/bin/env Rscript

library(rlang)
library(magrittr)
library(argparse)

parser = argparse::ArgumentParser()

parser$add_argument(
  "--input_feature_file",
  type = "character",
  required = TRUE
)

parser$add_argument(
  "--input_mutation_file",
  type = "character",
  required = TRUE
)

parser$add_argument(
  "--input_group_file",
  type = "character",
  required = TRUE
)

parser$add_argument(
  "--input_file_type",
  type = "character",
  default = "feather"
)

parser$add_argument(
  "--output_file",
  type = "character",
  default = "driver_results.feather"
)

parser$add_argument(
  "--output_file_type",
  type = "character",
  default = "feather"
)

parser$add_argument(
  "--feature_sample_column",
  type = "character",
  default = "sample"
)

parser$add_argument(
  "--feature_name_column",
  type = "character",
  default = "feature"
)

parser$add_argument(
  "--feature_value_column",
  type = "character",
  default = "value"
)

parser$add_argument(
  "--group_sample_column",
  type = "character",
  default = "sample"
)

parser$add_argument(
  "--group_name_column",
  type = "character",
  default = "group"
)

parser$add_argument(
  "--mutation_name_columns",
  type = "character",
  default = "mutation",
  nargs = '+'
)

parser$add_argument(
  "--mutation_name_separator",
  type = "character",
  default = ":"
)

parser$add_argument(
  "--mutation_sample_column",
  type = "character",
  default = "sample"
)

parser$add_argument(
  "--mutation_status_column",
  type = "character",
  default = "status"
)

args <- parser$parse_args()

if(args$input_file_type == "feather") {
  read_func <- feather::read_feather
} else if(args$input_file_type == "csv") {
  read_func <- readr::read_csv
} else if(args$input_file_type == "tsv") {
  read_func <- readr::read_tsv
} else {
  stop("Unsupported input file type")
}

if(args$output_file_type == "feather") {
  write_func <- feather::write_feather
} else if(args$output_file_type == "csv") {
  write_func <- readr::write_csv
} else if(args$output_file_type == "tsv") {
  write_func <- readr::write_tsv
} else {
  stop("Unsupported output file type")
}

feature_tbl <- args$input_feature_file %>% 
  read_func() %>% 
  dplyr::select(
    "sample" = args$feature_sample_column, 
    "feature" = args$feature_name_column,
    "value" = args$feature_value_column
  )

group_tbl <- args$input_group_file %>% 
  read_func() %>% 
  dplyr::select(
    "sample" = args$group_sample_column, 
    "group" = args$group_name_column, 
  )

mutation_tbl <-  args$input_mutation_file %>% 
  read_func() %>% 
  tidyr::unite(
    "mutation", 
    args$mutation_name_columns, 
    sep = args$mutation_name_separator
  ) %>% 
  dplyr::select(
    "sample" = args$mutation_sample_column,
    "mutation",
    "status" = args$mutation_status_column,
  ) %>% 
  dplyr::inner_join(group_tbl, by = "sample")


group_size_tbl <- mutation_tbl %>% 
  dplyr::group_by(.data$mutation, .data$group) %>%
  dplyr::summarise(
    "n_wt" = sum(.data$status == "Wt"),
    "n_mut" = dplyr::n() - .data$n_wt,
    .groups = "drop"
  ) %>%
  dplyr::filter(dplyr::across(c("n_wt", "n_mut"), ~.x > 2)) 

model_tbl <- 
  dplyr::full_join(
    dplyr::distinct(dplyr::select(mutation_tbl, "mutation", "group")),
    dplyr::distinct(dplyr::select(feature_tbl, "feature")),
    by = character()
  ) %>% 
  dplyr::inner_join(group_size_tbl, by = c("mutation", "group"))

calculate_lm_pvalue <- function(.data){
  lm(formula = value ~ status, data = .data) %>%
    summary %>%
    magrittr::use_series(coefficients) %>%
    .["statusWt", "Pr(>|t|)"] 
}

calculate_fold_change <- function(data){
  data %>% 
    dplyr::group_by(.data$status) %>% 
    dplyr::summarise("m" = mean(.data$value), .groups = "drop") %>% 
    dplyr::ungroup() %>% 
    tidyr::pivot_wider(
      names_from = "status", values_from = "m"
    ) %>% 
    dplyr::mutate(effect_size = .data$Wt/.data$Mut) %>% 
    dplyr::pull("effect_size")
}

calculate_metrics <- function(.feature, .mutation, .group){
  data <- purrr::reduce(
    .x = list(
      dplyr::filter(feature_tbl, .data$feature == .feature),
      dplyr::filter(
        mutation_tbl, 
        .data$mutation == .mutation, 
        .data$group == .group
      )
    ),
    .f = dplyr::inner_join,
    by = "sample"
  ) %>%
    tidyr::drop_na() %>% 
    dplyr::select("value", "status") 
  
  dplyr::tibble(
    "p_value" = calculate_lm_pvalue(data),
    "fold_change" = calculate_fold_change(data),
  ) 
}

model_tbl %>% 
  dplyr::mutate("results" = purrr::pmap(
    list(.data$feature, .data$mutation, .data$group), 
    calculate_metrics)
  ) %>% 
  tidyr::unnest(cols = "results") %>% 
  dplyr::mutate(
    "log10_pvalue" = -log10(.data$p_value),
    "log10_fold_change" = -log10(.data$fold_change)
  ) %>% 
  write_func(., args$output_file)

  

