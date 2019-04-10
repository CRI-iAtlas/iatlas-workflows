library(argparse)
library(magrittr)
library(tidyr)
library(dplyr)


parser = ArgumentParser()

parser$add_argument(
    "-a",
    "--tcr_alpha_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-b",
    "--tcr_beta_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-k",
    "--bcr_heavy_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-l",
    "--bcr_light_chain_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-s",
    "--sample_name",
    type = "character",
    required = TRUE)

args <- parser$parse_args()

chains <- c("tcr_alpha", "tcr_beta", "bcr_heavy", "bcr_light")

res <- 
    c(
        args$tcr_alpha_chain_file, 
        args$tcr_beta_chain_file,
        args$bcr_heavy_chain_file,
        args$bcr_light_chain_file) %>% 
    purrr::map(readr::read_tsv) %>% 
    purrr::map2(chains, ~dplyr::mutate(.x, chain = .y)) %>% 
    dplyr::bind_rows() %>% 
    dplyr::mutate(sample = args$sample_name) %>% 
    dplyr::select("sample", "chain", "cloneCount", "nSeqCDR3", "aaSeqCDR3") %>% 
    magrittr::set_colnames(c(
        "sample",
        "chain",
        "Read count",
        "CDR3 nucleotide sequence",
        "CDR3 amino acid sequence")) %>% 
    readr::write_tsv("cdr3.tsv", col_names = F)

