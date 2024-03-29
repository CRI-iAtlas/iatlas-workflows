library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--cohorts",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--mutations",
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
    "--codes",
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
    "--types",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--status",
    default = NULL,
    type = "character",
    nargs = "+"
)

args <- parser$parse_args()

argument_list <- purrr::map_if(args, is.null, ~return(NA)) 

result <- purrr::invoke(
    iatlas.api.client::query_mutation_statuses,
    argument_list
)

print(result)

arrow::write_feather(
    result,
    "mutations.feather",
    compression = "uncompressed"
)




