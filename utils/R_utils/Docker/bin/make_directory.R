library(argparse)
library(purrr)

parser = ArgumentParser(description = "Create directory with input files")

parser$add_argument(
    "--files",
    type = "character",
    nargs = "+",
    required = TRUE,
    help = "array of files to put into directory")

parser$add_argument(
    "--output_dir_string",
    default = "./file_dir",
    type = "character",
    help = "Path to output directory.")


args <- parser$parse_args()

dir.create(args$output_dir_string)

purrr::walk(args$files, file.copy, args$output_dir_string)