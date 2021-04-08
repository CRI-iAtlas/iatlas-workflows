library(EPIC)
library(argparse)
library(readr)
library(tibble)
library(magrittr)
library(arrow)
library(stringr)

parser = ArgumentParser(description = "Deconvolute tumor samples with EPIC")

parser$add_argument(
    "--input_expression_file",
    type = "character",
    required = TRUE,
    help = "Path to input table of expression data")


parser$add_argument(
    "--output_file",
    default = "./output_file.RDS",
    type = "character",
    help = "Path to output file.")
parser$add_argument(
    "--reference",
    default = 'TRef',
    type = "character",
    help = "Either 'TRef', BRef'")
parser$add_argument(
    "--scaleExprs",
    action = "store_true",
    help = "Boolean telling if the bulk samples and reference gene expression profiles should be rescaled based on the list of genes in common between the them (such a rescaling is recommanded).")
parser$add_argument(
    "--withOtherCells",
    action = "store_true",
    help = "If EPIC should allow for an additional cell type for which no gene expression reference profile is available or if the bulk is assumed to be composed only of the cells with reference profiles.")
parser$add_argument(
    "--constrainedSum",
    action = "store_true",
    help = "Tells if the sum of all cell types should be constrained to be < 1. When withOtherCells=FALSE, there is additionally a constrain the the sum of all cell types with reference profiles must be > 0.99.")
parser$add_argument(
    "--rangeBasedOptim",
    action = "store_true",
    help = "See documentation")



args <- parser$parse_args()

file <- args$input_expression_file
if(stringr::str_detect(file, ".feather")){
    expression <- arrow::read_feather(file)
} else if(stringr::str_detect(file, ".tsv")){
    expression <- readr::read_tsv(file)
} else if(stringr::str_detect(file, ".csv")){
    expression <- readr::read_csv(file)
}

expression <- expression %>% 
    as.data.frame() %>% 
    tibble::column_to_rownames(., colnames(.)[[1]]) %>% 
    as.matrix()

result_obj <- EPIC(
    expression,
    reference = args$reference,
    scaleExprs = args$scaleExprs,
    withOtherCells = args$withOtherCells,
    constrainedSum = args$constrainedSum,
    rangeBasedOptim = args$rangeBasedOptim)

saveRDS(result_obj, args$output_file)