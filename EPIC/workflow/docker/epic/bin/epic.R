library(EPIC)
library(argparse)

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
    "--reference_type",
    default = NULL,
    type = "character",
    help = "One of NULL, 'TRef', BRef', 'list'. If list, refProfiles, sigGenes args must be given. See documetation for full description")
parser$add_argument(
    "--ref_profiles_file",
    default = NULL,
    type = "character",
    help = "Path to input matrix of reference data, tab seperated. A matrix (nGenes x nCellTypes) of the reference cells genes expression (without the cancer cell type); the rownames needs to be defined as well as the colnames giving the names of each gene and reference cell types respectively")
parser$add_argument(
    "--ref_profiles_variability_file",
    default = NULL,
    type = "character",
    help = "Path to input matrix of reference variability data, tab seperated. A matrix (nGenes x nCellTypes) of the variability of each gene expression for each cell type, which is used to define weights on each gene for the optimization (if this is absent, we assume an identical variability for all genes in all cells) - it needs to have the same dimnames than refProfiles")
parser$add_argument(
    "--sigGenes_string",
    default = NULL,
    type = "character",
    help = "String converted into vector for mRNA_cell_sub, see documentation, ie. 'gene1,gene2,gene3'.")
parser$add_argument(
    "--mRNA_cell_string",
    default = NULL,
    type = "character",
    help = "String converted into vector for mRNA_cell, see documentation, ie. 'Bcells,NKcells,otherCells,default;2,2.1,3.5,1'")
parser$add_argument(
    "--mRNA_cell_sub_string",
    default = NULL,
    type = "character",
    help = "String converted into vector for mRNA_cell_sub, see documentation, ie. 'Bcells,NKcells,otherCells,default;2,2.1,3.5,1'")
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


read_table <-  function(file){
    read.table(
        file,
        sep = "\t",
        stringsAsFactors = FALSE,
        header = TRUE)
}


bulk <- read_table(args$input_expression_file)


if (is.null(args$reference_type)) {
    reference <- NULL
} else if (args$reference_type == 'list'){
    ref_profiles <- read_table(args$input_expression_file)
    sig_genes <- strsplit(args$sigGenes_string, ",")
    if(!is.null(args$ref_profiles_variability_file)){
        ref_profiles_variability <- read_table(args$ref_profiles_variability_file)
    }
    reference <- list(ref_profiles, sig_genes, ref_profiles_variability)
} else{
    reference <- args$reference_type
} 


if(!is.null(args$mRNA_cell_string)){
    mRNA_cell <- strsplit(args$mRNA_cell_string, ",")
} else {
    mRNA_cell <- NULL
}

if(!is.null(args$mRNA_cell_sub_string)){
    mRNA_cell_sub <- strsplit(args$mRNA_cell_sub_string, ",")
} else {
    mRNA_cell_sub <- NULL
}

result_obj <- EPIC(
    bulk,
    reference,
    mRNA_cell,
    mRNA_cell_sub,
    scaleExprs = args$scaleExprs,
    withOtherCells = args$withOtherCells,
    constrainedSum = args$constrainedSum,
    rangeBasedOptim = args$rangeBasedOptim)

saveRDS(result_obj, args$output_file)