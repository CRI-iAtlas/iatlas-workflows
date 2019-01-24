library(argparse)
library(magrittr)
library(purrr)
library(readr)
library(dplyr)
library(stringr)

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
    "-t",
    "--translation_file",
    type = "character",
    required = TRUE,
    help = "translation tsv file for kallisto transcripts to hugo gene names")

parser$add_argument(
    "-a",
    "--abundance_type",
    type = "character",
    default = "tpm",
    help = "kallisto abundance_type to use, could also be 'est_counts'")


args <- parser$parse_args()

translation_df <- readr::read_tsv(args$translation_file)

df <- args$abundance_files %>% 
    purrr::map(readr::read_tsv) %>% 
    purrr::map(dplyr::select, "target_id", args$abundance_type) %>% 
    purrr::reduce(dplyr::left_join, by = "target_id") %>% 
    magrittr::set_colnames(c("transcript", args$sample_names)) %>% 
    dplyr::mutate(transcript = stringr::str_sub(transcript, end = -3)) %>% 
    dplyr::inner_join(translation_df, by = "transcript") %>% 
    dplyr::select(Hugo, everything()) %>% 
    dplyr::select(-transcript) %>% 
    dplyr::group_by(Hugo) %>% 
    dplyr::summarise_all(sum) %>% 
    dplyr::ungroup()

readr::write_tsv(df, "expression_file.tsv")
    
    
