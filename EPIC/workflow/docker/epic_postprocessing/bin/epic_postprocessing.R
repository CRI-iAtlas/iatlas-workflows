library(argparse)
library(readr)
library(tibble)
library(magrittr)

parser = ArgumentParser()

parser$add_argument(
    "--input_epic_file",
    type = "character",
    required = TRUE)

parser$add_argument(
    "--output_file",
    default = "./output.tsv",
    type = "character",
    help = "Path to output file.")

args <- parser$parse_args()

args$input_epic_file %>%
    readRDS() %>% 
    magrittr::use_series(cellFractions) %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    tibble::as_tibble() %>% 
    readr::write_tsv(args$output_file)
