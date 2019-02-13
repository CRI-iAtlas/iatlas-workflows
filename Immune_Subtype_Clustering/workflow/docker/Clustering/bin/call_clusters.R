library(argparse)
library(magrittr)
library(readr)
library(stringr)
library(tibble)
library(dplyr)
library(tidyr)

parser = ArgumentParser(description = 'Call Immune subtype clusters on expression data.')

# required args

parser$add_argument(
    "-i",
    "--input_file",
    type = "character",
    required = TRUE,
    help = "Path to expression file.")

# optional argumennts
parser$add_argument(
    "-o",
    "--output_name",
    type = "character",
    default = "immune_subtypes.tsv",
    help = "Output file name")
parser$add_argument(
    "-d",
    "--input_file_delimeter",
    type = "character",
    default = "\t")
parser$add_argument(
    "-n",
    "--num_cores",
    type = "integer",
    default = 1)
parser$add_argument(
    "-e",
    "--ensemble_size",
    type = "integer",
    default = 256)
parser$add_argument(
    "-l",
    "--log_expression",
    action = "store_true")
parser$add_argument(
    "-c",
    "--combat_normalize",
    action = "store_true")


args <- parser$parse_args()



source("/usr/local/bin/computing_scores_and_calling_clusters.R")

input_df <- readr::read_delim(
    args$input_file, 
    delim = args$input_file_delimeter 
)

sample_names <- input_df %>% 
    colnames() %>% 
    magrittr::extract(-1)


result_df <- input_df %>% 
    tidyr::drop_na() %>% 
    data.frame() %>% 
    newScores(
        logflag = args$log_expression, 
        cores = args$num_cores, 
        ensemblesize = args$ensemble_size, 
        combatflag = args$combat_normalize
    ) %>%
    magrittr::use_series(AlignedCalls) %>% 
    tibble::enframe("sample", "immune_subtype") %>% 
    dplyr::mutate(immune_subtype = stringr::str_c("C", immune_subtype)) %>% 
    mutate(sample = sample_names) %>% 
    readr::write_tsv(args$output_name)


