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
    "--input_type",
    type = "character",
    default = "long"
)

parser$add_argument(
    "--output_type",
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
    "--id_column",
    type = "character",
    nargs = "+",
    default = NULL
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

expression_df <- read_func(args$input_file)

if (is.null(args$output_type)) {
    expression_df <- expression_df
} else if (args$input_type == args$output_type){
    expression_df <- expression_df
} else if(args$input_type == "long") {
    expression_df  <- expression_df %>% 
        dplyr::select(dplyr::all_of(c(
            args$id_column, args$name_column, args$value_column
        ))) %>% 
        tidyr::pivot_wider(
            id_cols = args$id_column,
            names_from = args$name_column,
            values_from = args$value_column
        ) 
} else if (args$input_type == "wide"){
    expression_df <- tidyr::pivot_longer(
        data = expression_df,
        cols = -c(args$id_column),
        names_to = args$name_column,
        values_to = args$value_column
    )
} else {
    stop("Unsupported input or output type")
}

write_func(expression_df, args$output_file)
    
    
    
