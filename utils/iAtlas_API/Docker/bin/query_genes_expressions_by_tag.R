library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--datasets",
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--parent_tags",
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--tags",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--entrez",
    default = NULL,
    type = "integer",
    nargs = "+"
)

parser$add_argument(
    "--gene_types",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--features",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--feature_classes",
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

args <- parser$parse_args()

argument_list <- purrr::map_if(args, is.null, ~return(NA)) 

result <- purrr::invoke(
    iatlas.api.client::query_genes_expression_by_tag,
    argument_list
)

print(result)

arrow::write_feather(result, "gene_expression.feather")




