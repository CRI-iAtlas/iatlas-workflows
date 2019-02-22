library(argparse)
library(magrittr)
library(purrr)
library(readr)
library(tidyr)
library(dplyr)

parser = ArgumentParser(description = "Combine multiple kallisto files into one table")

parser$add_argument(
    "-f",
    "--abundance_files",
    type = "character",
    nargs = "+",
    required = TRUE,
    help = "array of kallisto abundance tsv files to combine")

parser$add_argument(
    "-s",
    "--sample_names",
    type = "character",
    nargs = "+",
    required = TRUE,
    help = "array of sample names in same order as kallisto files")

parser$add_argument(
    "-a",
    "--abundance_type",
    type = "character",
    default = "tpm",
    help = "kallisto abundance_type to use, could also be 'est_counts'")


args <- parser$parse_args()

df <- args$abundance_files %>% 
    purrr::map(readr::read_tsv) %>% 
    purrr::map(dplyr::select, "target_id", args$abundance_type) %>% 
    purrr::reduce(dplyr::left_join, by = "target_id") %>% 
    magrittr::set_colnames(c("transcript", args$sample_names)) %>% 
    tidyr::separate(
        transcript, 
        into = c("value1", "value2", "value3", "value4", "value5", "Hugo"), 
        sep = "\\|", 
        extra = "drop") %>% 
    dplyr::select(-c("value1", "value2", "value3", "value4", "value5")) %>% 
    dplyr::group_by(Hugo) %>%
    dplyr::summarise_all(sum) %>%
    dplyr::ungroup()

readr::write_tsv(df, "expression_file.tsv")
    
    
