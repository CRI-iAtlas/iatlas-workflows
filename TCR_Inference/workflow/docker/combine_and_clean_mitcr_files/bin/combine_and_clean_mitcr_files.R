library(argparse)
library(magrittr)
library(tidyr)
library(dplyr)


parser = ArgumentParser(description = "Combine Cibersort cell types into aggregates")

parser$add_argument(
    "-a",
    "--alpha_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-b",
    "--beta_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-s",
    "--sample_name",
    type = "character",
    required = TRUE)

args <- parser$parse_args()

alpha_chain_df <- args$alpha_chain_file %>% 
    readr::read_tsv(skip = 1) %>% 
    magrittr::inset("chain", value = "alpha")

beta_chain_df <- args$beta_chain_file %>% 
    readr::read_tsv(skip = 1) %>% 
    magrittr::inset("chain", value = "beta") 

combined_df <-
    dplyr::bind_rows(alpha_chain_df, beta_chain_df) %>% 
    magrittr::inset("sample", value = args$sample_name) %>% 
    dplyr::select("sample", "chain", "Read count", "CDR3 nucleotide sequence", "CDR3 amino acid sequence") %>% 
    readr::write_tsv("cdr3.tsv", col_names = F)

