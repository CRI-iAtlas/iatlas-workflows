library(argparse)
library(magrittr)
library(ImmuneSubtypeClassifier)

parser = ArgumentParser(description = 'Call Immune subtype clusters on expression data.')

# required args

parser$add_argument(
    "-i",
    "--input_file",
    type = "character",
    required = TRUE,
    help = "Path to expression file.")

# optional argumennts
parser$add_argument(
    "-o",
    "--output_name",
    type = "character",
    default = "immune_subtypes.tsv",
    help = "Output file name")
parser$add_argument(
    "-d",
    "--input_file_delimeter",
    type = "character",
    default = "\t")
parser$add_argument(
    "-g",
    "--input_gene_column",
    type = "character",
    default = "Hugo")


args <- parser$parse_args()

args$input_file %>% 
    readr::read_delim(delim = args$input_file_delimeter) %>% 
    as.data.frame() %>% 
    tibble::column_to_rownames(args$input_gene_column) %>% 
    as.matrix() %>% 
    ImmuneSubtypeClassifier::callEnsemble() %>% 
    tibble::as_tibble() %>% 
    dplyr::select(sample = SampleIDs, subtype = BestCall) %>% 
    dplyr::mutate(
        sample = as.character(sample),
        subtype = paste0("C", subtype),
    ) %>% 
    readr::write_tsv(args$output_name)







