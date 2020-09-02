library(argparse)

parser = argparse::ArgumentParser(description = "")

parser$add_argument(
    "--datasets",
    default = NULL,
    type = "character",
    nargs = "+"
)

parser$add_argument(
    "--parent_tags",
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
    iatlas.api.client::query_samples_by_tag,
    argument_list
) 

print(result)

feather::write_feather(result, "samples_by_tags.feather")




