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
    read.table(sep = "\t", stringsAsFactors = F) %>%
    magrittr::set_rownames(
        ., 
        format_cell_types(rownames(.))
    ) %>% 
    t %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    tibble::as_tibble() %>% 
    readr::write_tsv(., args$output_file)
