library(argparse)
library(magrittr)

parser = ArgumentParser()

parser$add_argument(
    "-i",
    "--input_file",
    type = "character",
    required = TRUE)

parser$add_argument(
    "-o",
    "--output_file",
    type = "character",
    required = TRUE)

parser$add_argument(
    "-m",
    "--parse_method",
    type = "character",
    default = "kallisto")

parser$add_argument(
    "-e",
    "--kallisto_expr_column",
    type = "character",
    default = "tpm")

parser$add_argument(
    "-g",
    "--kallisto_gene_column",
    type = "character",
    default = "value6")


args <- parser$parse_args()

if(args$parse_method == "kallisto"){
    args$input_file %>%   
        readr::read_tsv() %>% 
        tidyr::separate(
            target_id, 
            into = c(
                "value1", 
                "value2", 
                "value3", 
                "value4", 
                "value5", 
                "value6"), 
            sep = "\\|", 
            extra = "drop") %>% 
        dplyr::select(
            "Gene" = args$kallisto_gene_column, 
            args$kallisto_expr_column
        ) %>% 
        dplyr::group_by(Gene) %>%
        dplyr::summarise_all(sum) %>%
        dplyr::ungroup() %>% 
        readr::write_tsv(args$output_file)
} else {
    stop("Method doesn't exist")
}


    
    
    
