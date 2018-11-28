library(DeconRNASeq)
library(argparse)
library(readr)
library(tibble)
library(magrittr)

parser = ArgumentParser(description = "Deconvolute tumor samples with DeconRNASeq")


print("test1")
# required args
parser$add_argument(
    "--input_expression_file",
    type = "character",
    required = TRUE,
    help = "Path to input matrix of expression data, tab seperated. Measured mixture data matrix, genes (transcripts) e.g. gene counts by samples, . The user can choose the appropriate counts, RPKM, FPKM etc..")
parser$add_argument(
    "--input_signature_file",
    type = "character",
    required = TRUE,
    help = "Path to input matrix of signature data, tab seperated. Signature matrix from different tissue/cell types, genes (transcripts) by cell types. For gene counts, the user can choose the appropriate counts, RPKM, FPKM etc..")

# with defaults
parser$add_argument(
    "--output_file",
    type = "character",
    default = "./output_file.RDS",
    help = "path to write output file")
parser$add_argument(
    "--input_proportions_file",
    default = NULL,
    type = "character",
    help = "Path to input matrix of proportion data, tab seperated. Proportion matrix from different tissue/cell types.")
parser$add_argument(
    "--checksig",
    action = "store_true",
    help = "Whether the condition number of signature matrix should be checked.")
parser$add_argument(
    "--known.prop",
    action = "store_true",
    help = "Whether the proportions of cell types have been known in advanced for proof of concept.")
parser$add_argument(
    "--use.scale",
    action = "store_false",
    help = "Whether the data should be centered or scaled.")
parser$add_argument(
    "--fig",
    action = "store_false",
    help = "Whether to generate the scatter plots of the estimated cell fractions vs. the true proportions of cell types.")

args = parser$parse_args()

tsv_file_to_df <- function(file){
    file %>% 
        readr::read_tsv() %>% 
        as.data.frame() %>% 
        tibble::column_to_rownames(., colnames(.)[[1]])
}

datasets <-  tsv_file_to_df(args$input_expression_file)

signatures <- tsv_file_to_df(args$input_signature_file)

print("test2")

if(is.character(args$input_proportions_file)){
    proportions <- tsv_file_to_matrix(args$input_proportions_file)
} else {
    proportions <- NULL
}

decon_obj <- DeconRNASeq(
    datasets, 
    signatures, 
    proportions, 
    args$checksig,
    args$known.prop,
    args$use.scale,
    args$fig)

saveRDS(decon_obj, args$output_file)
