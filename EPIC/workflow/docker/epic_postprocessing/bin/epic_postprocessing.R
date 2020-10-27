library(argparse)
library(magrittr)

parser = ArgumentParser()

parser$add_argument(
    "--input_epic_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--output_file",
    default = "./output.tsv",
    type = "character",
    help = "Path to output file."
)

args <- parser$parse_args()

celltype_list <- list(
    "Bcells"      = "EPIC_B_Cells",
    "CAFs"        = "EPIC_CAFs",
    "CD4_Tcells"  = "EPIC_CD4_T_Cells",
    "CD8_Tcells"  = "EPIC_CD8_T_Cells",
    "Endothelial" = "EPIC_Endothelial",
    "Macrophages" = "EPIC_Macrophages",
    "NKcells"     = "EPIC_NK_Cells",
    "otherCells"  = "EPIC_Other_Cells"
)

args$input_epic_file %>%
    readRDS() %>% 
    purrr::pluck("cellFractions") %>% 
    magrittr::set_colnames(., purrr::map(colnames(.), ~celltype_list[[.x]])) %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("sample") %>% 
    tibble::as_tibble() %>% 
    readr::write_tsv(args$output_file)
