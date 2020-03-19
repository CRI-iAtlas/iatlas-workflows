library(argparse)
library(readr)
library(tibble)
library(magrittr)


parser = ArgumentParser(
    description = "Deconvolute tumor samples with MCPcounter"
)

parser$add_argument(
    "--input_mcpcounter_file",
    type = "character",
    required = TRUE,
    help = "Path to input mcpcpunter file."
)
parser$add_argument(
    "--output_file",
    default = "./output_file.tsv",
    type = "character",
    help = "Path to output file."
)

args = parser$parse_args()

args$input_mcpcounter_file %>% 
    read.table(sep = "\t", stringsAsFactors = F) %>%
    magrittr::set_rownames(
        ., 
        stringr::str_replace_all(rownames(.), " ", "_")
    ) %>% 
    t %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    tibble::as_tibble() %>% 
    readr::write_tsv(., args$output_file)
