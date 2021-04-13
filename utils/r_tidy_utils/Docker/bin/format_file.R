library(argparse)
library(magrittr)
library(rlang)

parser = argparse::ArgumentParser()

parser$add_argument(
    "--input_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--output_file",
    type = "character",
    default = NA_character_
)

parser$add_argument(
    "--input_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--output_file_type",
    type = "character",
    default = NA_character_
)

parser$add_argument(
    "--input_type",
    type = "character",
    default = "long"
)

parser$add_argument(
    "--output_type",
    type = "character",
    default = NA_character_
)

parser$add_argument(
    "--value_column",
    type = "character",
    default = "value"
)

parser$add_argument(
    "--name_column",
    type = "character",
    default = "name"
)

parser$add_argument(
    "--id_columns",
    type = "character",
    nargs = "+",
    default = NULL
)

args <- parser$parse_args()

if(is.na(args$output_file)) {
    output_file <- args$input_file
} else {
    output_file <- args$output_file
}

if(args$input_file_type == "feather") {
    read_func <- arrow::read_feather
} else if(args$input_file_type == "csv") {
    read_func <- readr::read_csv
} else if(args$input_file_type == "tsv") {
    read_func <- readr::read_tsv
} else {
    stop("Unsupported input file type")
}

if(args$output_file_type == "feather") {
    write_func <- arrow::write_feather
} else if(args$output_file_type == "csv") {
    write_func <- readr::write_csv
} else if(args$output_file_type == "tsv") {
    write_func <- readr::write_tsv
} else {
    write_func <- args$input_file_type
}

expression_df <- read_func(args$input_file)

if (is.na(args$output_type)) {
    expression_df <- expression_df
} else if (args$input_type == args$output_type){
    expression_df <- expression_df
} else if(args$input_type == "long") {
    expression_df <- tidyr::pivot_wider(
        data = expression_df,
        id_cols = args$id_columns,
        names_from = args$name_column,
        values_from = args$value_column
    )
} else if (args$input_type == "wide"){
    expression_df <- tidyr::pivot_longer(
        data = expression_df,
        cols = -c(args$id_columns),
        names_to = args$name_column,
        values_to = args$value_column
    )
} else {
    stop("Unsupported input or output type")
}

write_func(expression_df, args$output_file)
    
    
    
