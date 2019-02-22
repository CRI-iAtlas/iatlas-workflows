library(argparse)
library(magrittr)
library(purrr)
library(readr)
library(dplyr)

parser = ArgumentParser(description = "Combine multiple tabular files into one.")

parser$add_argument(
    "-f",
    "--files",
    type = "character",
    nargs = "+",
    required = TRUE,
    help = "array of tabular files to combine")

parser$add_argument(
    "-i",
    "--input_delimiter",
    type = "character",
    default = "\t")

parser$add_argument(
    "-o",
    "--output_delimiter",
    type = "character",
    default = "\t")

parser$add_argument(
    "-n",
    "--output_file_name",
    type = "character",
    default = "output.tsv")

args <- parser$parse_args()

args$files %>% 
    purrr::map(readr::read_delim, delim = args$input_delimiter) %>% 
    dplyr::bind_rows() %>% 
    readr::write_delim(args$output_file_name, delim = args$output_delimiter)
    
    
