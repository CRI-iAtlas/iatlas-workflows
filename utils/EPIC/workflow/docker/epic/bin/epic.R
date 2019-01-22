library(EPIC)
library(argparse)
library(readr)
library(tibble)
library(magrittr)

parser = ArgumentParser(description = "Deconvolute tumor samples with EPIC")

parser$add_argument(
    "--input_expression_file",
    type = "character",
    required = TRUE,
    help = "Path to input matrix of microarray expression data, tab seperated. A matrix (nGenes x nSamples) of the genes expression from each bulk sample (the counts should be given in TPM or RPKM when using the prebuilt reference profiles). This matrix needs to have rownames telling the gene names (corresponds to the gene symbol in the prebuilt reference profiles (e.g. CD8A, MS4A1) - no conversion of IDs is performed at the moment).")


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
    action = "store_false",
    help = "Boolean telling if the bulk samples and reference gene expression profiles should be rescaled based on the list of genes in common between the them (such a rescaling is recommanded).")
parser$add_argument(
    "--withOtherCells",
    action = "store_false",
    help = "If EPIC should allow for an additional cell type for which no gene expression reference profile is available or if the bulk is assumed to be composed only of the cells with reference profiles.")
parser$add_argument(
    "--constrainedSum",
    action = "store_false",
    help = "Tells if the sum of all cell types should be constrained to be < 1. When withOtherCells=FALSE, there is additionally a constrain the the sum of all cell types with reference profiles must be > 0.99.")
parser$add_argument(
    "--rangeBasedOptim",
    action = "store_true",
    help = "See documentation")



args <- parser$parse_args()

tsv_file_to_matrix <- function(file){
    file %>% 
        readr::read_tsv() %>% 
        as.data.frame() %>% 
        tibble::column_to_rownames(., colnames(.)[[1]]) %>% 
        as.matrix()
}

bulk <- tsv_file_to_matrix(args$input_expression_file)

result_obj <- EPIC(
    bulk,
    reference = args$reference,
    scaleExprs = args$scaleExprs,
    withOtherCells = args$withOtherCells,
    constrainedSum = args$constrainedSum,
    rangeBasedOptim = args$rangeBasedOptim)

saveRDS(result_obj, args$output_file)