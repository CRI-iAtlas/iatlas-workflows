library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--gene_types",
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
    "--samples",
    default = NULL,
    type = "character",
    nargs = "+"
)

args <- parser$parse_args()

argument_list <- purrr::map_if(args, is.null, ~return(NA)) 

result <- purrr::invoke(
    iatlas.api.client::query_expression_by_genes,
    argument_list
)

print(result)

feather::write_feather(result, "expression_by_genes.feather")




