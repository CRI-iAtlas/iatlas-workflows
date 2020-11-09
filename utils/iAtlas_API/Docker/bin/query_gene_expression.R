library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--datasets",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--entrez",
    default = NULL,
    type = "integer"
)

parser$add_argument(
    "--gene_types",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--max_rnaseq_expr",
    default = NULL,
    type = "double"
)

parser$add_argument(
    "--min_rnaseq_expr",
    default = NULL,
    type = "double"
)

parser$add_argument(
    "--parent_tags",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--samples",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--tags",
    default = NULL,
    type = "character",
    nargs = "+"
)

args <- parser$parse_args()

argument_list <- purrr::map_if(args, is.null, ~return(NA)) 

result <- purrr::invoke(
    iatlas.api.client::query_gene_expression,
    argument_list
)

print(result)

arrow::write_feather(result, "gene_expression.feather")




