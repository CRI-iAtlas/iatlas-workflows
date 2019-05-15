library(argparse)
library(magrittr)
library(readr)

parser = ArgumentParser(description = "Split tabular file by column.")

parser$add_argument(
    "-f",
    "--file",
    type = "character",
    required = TRUE)

parser$add_argument(
    "-i",
    "--input_delimiter",
    type = "character",
    default = "\t")

parser$add_argument(
    "-n",
    "--output_file_prefix",
    type = "character",
    default = "output")

parser$add_argument(
    "-l",
    "--label_column",
    type = "int",
    default = 1)



args <- parser$parse_args()

args <- list(
    "file" = "../../../../sample_files/expression/expression.tsv",
    "input_delimiter" = "\t",
    "output_file_prefix" = "output",
    "label_column_index" = 1
)

split_matrix_into_cols <- function(mat){
    purrr::map(1:ncol(mat), ~magrittr::extract(mat, x))
}

df <- readr::read_delim(args$file, delim = args$input_delimiter)

label_column <- df %>% 
    colnames %>% 
    magrittr::extract(args$label_column_index)

output_files <- df %>% 
    ncol() %>% 
    magrittr::subtract(1) %>% 
    seq %>% 
    as.character() %>% 
    stringr::str_c(args$output_file_prefix, ., ".tsv")

df %>% 
    as.data.frame() %>% 
    tibble::column_to_rownames(label_column) %>% 
    split_matrix_into_cols %>% 
    purrr::map(as.data.frame) %>% 
    purrr::map(tibble::rownames_to_column, label_column) %>% 
    purrr::walk2(output_files, readr::write_tsv)
    
    
