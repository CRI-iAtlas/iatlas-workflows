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
    default = "expression.feather"
)

parser$add_argument(
    "--input_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--output_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--parse_method",
    type = "character",
    default = "long_expression"
)

# long expression arguments

parser$add_argument(
    "--expression_column",
    type = "character",
    default = "expression"
)

parser$add_argument(
    "--sample_column",
    type = "character",
    default = "sample"
)

# kallisto arguments
parser$add_argument(
    "--sample_name",
    type = "character",
    default = NULL
)

parser$add_argument(
    "--kallisto_expr_column",
    type = "character",
    default = "tpm"
)

parser$add_argument(
    "--kallisto_gene_column",
    type = "character",
    default = "value6"
)


args <- parser$parse_args()

if(args$input_file_type == "feather") {
    read_func <- feather::read_feather
} else if(args$input_file_type == "csv") {
    read_func <- readr::read_csv
} else if(args$input_file_type == "tsv") {
    read_func <- readr::read_tsv
} else {
    stop("Unsupported input file type")
}

if(args$output_file_type == "feather") {
    write_func <- feather::write_feather
} else if(args$output_file_type == "csv") {
    write_func <- readr::write_csv
} else if(args$output_file_type == "tsv") {
    write_func <- readr::write_tsv
} else {
    stop("Unsupported output file type")
}

expression_df <- read_func(args$input_file)

if (args$parse_method == "long_expression"){
    expression_df <- tidyr::pivot_wider(
        expression_df,
        names_from = args$sample_column,
        values_from = args$expression_column
    )
} else if (args$parse_method == "wide_expression"){
    #do nothing
} else if (args$parse_method == "kallisto"){
    if(is.null(args$sample_name)) stop("Must supply --sample_name")
    expression_df <- expression_df %>%   
        tidyr::separate(
            "target_id", 
            into = c(
                "value1", 
                "value2", 
                "value3", 
                "value4", 
                "value5", 
                "value6"), 
            sep = "\\|", 
            extra = "drop") %>% 
        dplyr::select(args$kallisto_gene_column, args$kallisto_expr_column) %>% 
        magrittr::set_colnames(., c("Gene", args$sample_name)) %>% 
        dplyr::group_by(.data$Gene) %>%
        dplyr::summarise_all(sum) %>%
        dplyr::ungroup() 
} else {
    stop("Method doesn't exist")
}

write_func(expression_df, args$output_file)
    
    
    
