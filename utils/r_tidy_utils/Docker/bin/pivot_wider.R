library(argparse)
library(magrittr)
library(rlang)

parser = argparse::ArgumentParser()

parser$add_argument(
    "--input_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--output_file",
    type = "character",
    default = "output.feather"
)

parser$add_argument(
    "--input_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--output_file_type",
    type = "character",
    default = NULL
)

parser$add_argument(
    "--value_column",
    type = "character",
    default = "value"
)

parser$add_argument(
    "--name_column",
    type = "character",
    default = "name"
)

parser$add_argument(
    "--drop_na",
    action = "store_true", 
    default = FALSE
)

args <- parser$parse_args()

if(args$input_file_type == "feather") {
    read_func <- arrow::read_feather
} else if(args$input_file_type == "csv") {
    read_func <- readr::read_csv
} else if(args$input_file_type == "tsv") {
    read_func <- readr::read_tsv
} else {
    stop("Unsupported input file type")
}

if(args$output_file_type == "feather") {
    write_func <- purrr::partial(
        arrow::write_feather, compression = "uncompressed"
    )
} else if(args$output_file_type == "csv") {
    write_func <- readr::write_csv
} else if(args$output_file_type == "tsv") {
    write_func <- readr::write_tsv
} else {
    write_func <- args$input_file_type
}

tbl <- read_func(args$input_file)

tbl <- tidyr::pivot_wider(
    data = tbl,
    names_from = args$name_column,
    values_from = args$value_column
)

if (args$drop_na){
    tbl <- tidyr::drop_na(tbl)
}

write_func(tbl, args$output_file)
    
    
    
