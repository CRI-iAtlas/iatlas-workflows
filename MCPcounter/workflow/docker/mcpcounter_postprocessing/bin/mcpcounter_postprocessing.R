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

format_cell_types <- function(cells){
    cells %>% 
        stringr::str_to_title(.) %>% 
        stringr::str_replace_all(" ", "_") %>% 
        paste0("MCPcounter_", .)
}

args$input_mcpcounter_file %>% 
    readr::read_tsv() %>% 
    dplyr::mutate("feature" = format_cell_types(feature)) %>% 
    readr::write_tsv(., args$output_file)
