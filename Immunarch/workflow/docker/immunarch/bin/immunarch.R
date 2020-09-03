library(argparse)
library(magrittr)

parser = argparse::ArgumentParser(
    description = "Calculate immunarch metrics from mixcr/mitcr file"
)

parser$add_argument(
    "--input_files",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--output_file",
    type = "character",
    default = "immunarch.feather"
)

parser$add_argument(
    "--output_file_type",
    type = "character",
    default = "feather"
)

args <- parser$parse_args()

if(args$output_file_type == "feather") {
    write_func <- feather::write_feather
} else if(args$output_file_type == "csv") {
    write_func <- readr::write_csv
} else if(args$output_file_type == "tsv") {
    write_func <- readr::write_tsv
} else {
    stop("Unsupported output file type")
}

data <- args$input_files %>% 
    immunarch::repLoad(.) %>% 
    purrr::pluck("data")

distributions1 <- data %>% 
    immunarch::repExplore("volume") %>%  
    dplyr::as_tibble() %>% 
    dplyr::select("sample" = "Sample", "value" = "Volume") %>% 
    dplyr::mutate("feature" = "immunarch_n_unique_clonotypes")

distributions2 <- data %>% 
    immunarch::repExplore("clones") %>%  
    dplyr::as_tibble() %>% 
    dplyr::select("sample" = "Sample", "value" = "Clones") %>% 
    dplyr::mutate("feature" = "immunarch_n_clones")

diversity1 <- data %>% 
    immunarch::repDiversity("chao1") %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    dplyr::as_tibble() %>% 
    dplyr::select("sample", "value" = "Estimator") %>% 
    dplyr::mutate("feature" = "immunarch_chao1_diversity")

diversity2 <- data %>% 
    immunarch::repDiversity("div") %>% 
    dplyr::select("sample" = "Sample", "value" = "Value") %>% 
    dplyr::mutate("feature" = "immunarch_true_diversity")

diversity3 <- data %>% 
    immunarch::repDiversity("gini.simp") %>% 
    dplyr::select("sample" = "Sample", "value" = "Value") %>% 
    dplyr::mutate("feature" = "immunarch_gini_simpson_diversity")

diversity4 <- data %>% 
    immunarch::repDiversity("inv.simp") %>% 
    dplyr::select("sample" = "Sample", "value" = "Value") %>% 
    dplyr::mutate("feature" = "immunarch_inverse_simpson_diversity")

diversity5 <- data %>% 
    immunarch::repDiversity("gini") %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    dplyr::as_tibble() %>% 
    dplyr::select("sample", "value" = "V1") %>% 
    dplyr::mutate("feature" = "immunarch_gini_diversity")

diversity6 <- data %>% 
    immunarch::repDiversity("d50") %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    dplyr::as_tibble() %>% 
    dplyr::select("sample", "value" = "Clones") %>% 
    dplyr::mutate("feature" = "immunarch_d50_diversity")

diversity7 <- data %>% 
    immunarch::repDiversity("dxx") %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    dplyr::as_tibble() %>% 
    dplyr::select("sample", "value" = "Clones") %>% 
    dplyr::mutate("feature" = "immunarch_dx_diversity")

result <-
    list(
        distributions1, 
        distributions2, 
        diversity1, 
        diversity2, 
        diversity3,
        diversity4, 
        diversity5,
        diversity6,
        diversity7
    ) %>% 
    dplyr::bind_rows()

print(result)
    
write_func(result, args$output_file)
    


