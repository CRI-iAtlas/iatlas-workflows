library(MCPcounter)
library(argparse)
library(readr)
library(tibble)
library(magrittr)


parser = ArgumentParser(description = "Deconvolute tumor samples with MCPcounter")

parser$add_argument(
    "--input_expression_file",
    type = "character",
    required = TRUE,
    help = "Path to input matrix of microarray expression data. Tab separated file with features in rows and samples in columns.")
parser$add_argument(
    "--output_file",
    default = "./output_file.tsv",
    type = "character",
    help = "Path to output file.")
parser$add_argument(
    "--features_type",
    default = "affy133P2_probesets",
    type = "character",
    help = "Type of identifiers for expression features. Defaults to 'affy133P2_probesets' for Affymetrix Human Genome 133 Plus 2.0 probesets. Other options are 'HUGO_symbols' (Official gene symbols) or 'ENTREZ_ID' (Entrez Gene ID)")
parser$add_argument(
    "--input_probeset_file",
    default = "",
    type = "character",
    help = "Path to input table of gene data. Tab separated file of probesets transcriptomic markers and corresponding cell populations. Fetched from github by a call to read.table by default, but can also be a data.frame")
parser$add_argument(
    "--input_gene_file",
    default = "",
    type = "character",
    help = "Path to input table of gene data. Tab separated file of genes transcriptomic markers (HUGO symbols or ENTREZ_ID) and corresponding cell populations. Fetched from github by a call to read.table by default, but can also be a data.frame")

args = parser$parse_args()

tsv_file_to_matrix <- function(file){
    file %>% 
        readr::read_tsv() %>% 
        as.data.frame() %>% 
        tibble::column_to_rownames(., colnames(.)[[1]]) %>% 
        as.matrix()
}

expression <- tsv_file_to_matrix(args$input_expression_file)

arg_list = list("expression" = expression, "featuresType" = args$features_type)

if(!args$input_probeset_file == ""){
    probesets <- tsv_file_to_matrix(args$input_probeset_file)
    arg_list[['probesets']] <- probesets
}

if(!args$input_gene_file == ""){
    genes <- tsv_file_to_matrix(args$input_gene_file)
    arg_list[['genes']] <- genes
}

do.call(MCPcounter::MCPcounter.estimate, arg_list) %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("cell_type") %>% 
    readr::write_tsv(args$output_file)


