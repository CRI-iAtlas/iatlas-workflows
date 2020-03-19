library(argparse)
library(magrittr)
library(readr)
library(tidyr)
library(dplyr)

# Globals -----
CIBERSORT_CELLTYPES <- c(
    'Mixture', 
    'B cells naive', 
    'B cells memory', 
    'Plasma cells',
    'T cells CD8', 
    'T cells CD4 naive',
    'T cells CD4 memory resting',
    'T cells CD4 memory activated', 
    'T cells follicular helper', 
    'T cells regulatory (Tregs)',
    'T cells gamma delta', 
    'NK cells resting', 
    'NK cells activated', 
    'Monocytes', 
    'Macrophages M0', 
    'Macrophages M1', 
    'Macrophages M2', 
    'Dendritic cells resting',
    'Dendritic cells activated',
    'Mast cells resting',
    'Mast cells activated', 
    'Eosinophils', 
    'Neutrophils'
)

AGGREGATE_LIST <- list(
    "Lymphocytes_Aggregate1" = c(
        "B_cells_naive",
        "B_cells_memory",
        "T_cells_CD4_naive",
        "T_cells_CD4_memory_resting", 
        "T_cells_CD4_memory_activated",
        "T_cells_follicular_helper",
        "T_cells_regulatory_Tregs",
        "T_cells_gamma_delta",
        "T_cells_CD8",
        "NK_cells_resting",
        "NK_cells_activated",
        "Plasma_cells"
    ),
    
    "Neutrophils_Aggregate1" = "Neutrophils",
    "Eosinophils_Aggregate1" = "Eosinophils",
    "Mast_cells_Aggregate1"  = c("Mast_cells_resting", "Mast_cells_activated"),
    "Dendritic_cells_Aggregate1" = c(
        "Dendritic_cells_resting", 
        "Dendritic_cells_activated"
    ),
    "Macrophage_Aggregate1" = c(
        "Monocytes",
        "Macrophages_M0", 
        "Macrophages_M1",
        "Macrophages_M2"
    ),
    
    "Neutrophils_Aggregate2" = "Neutrophils",
    "Eosinophils_Aggregate2" = "Eosinophils",
    "Mast_cells_Aggregate2" = c("Mast_cells_resting", "Mast_cells_activated"),
    "Dendritic_cells_Aggregate2" = c(
        "Dendritic_cells_resting", 
        "Dendritic_cells_activated"
    ),
    
    "Macrophage_Aggregate2" = c(
        "Macrophages_M0", "Macrophages_M1", "Macrophages_M2"
    ),
    "NK_cells_Aggregate2" = c("NK_cells_resting", "NK_cells_activated"),
    "B_cells_Aggregate2" = c("B_cells_naive",  "B_cells_memory"),
    "T_cells_CD8_Aggregate2" = "T_cells_CD8",
    "T_cells_CD4_Aggregate2" = c(
        "T_cells_CD4_naive",
        "T_cells_CD4_memory_resting",
        "T_cells_CD4_memory_activated"
    ),

    "B_cells_Aggregate3" = c("B_cells_naive", "B_cells_memory"),
    "Plasma_cells_Aggregate3" = "Plasma_cells",
    "T_cells_CD8_Aggregate3" = "T_cells_CD8",
    "T_cells_CD4_Aggregate3" = c(
        "T_cells_CD4_naive",
        "T_cells_CD4_memory_resting",
        "T_cells_CD4_memory_activated",
        "T_cells_follicular_helper", 
        "T_cells_regulatory_Tregs"),
    "T_cells_gamma_delta_Aggregate3" = "T_cells_gamma_delta",
    "NK_cells_Aggregate3" = c("NK_cells_resting", "NK_cells_activated"),
    "Macrophage_Aggregate3" = c(
        "Monocytes", 
        "Macrophages_M0", 
        "Macrophages_M1", 
        "Macrophages_M2"),
    
    "Dendritic_cells_Aggregate3" = c(
        "Dendritic_cells_resting",
        "Dendritic_cells_activated"
    ),
    
    "Mast_cells_Aggregate3" = c("Mast_cells_resting", "Mast_cells_activated"),
    "Neutrophils_Aggregate3" = "Neutrophils",
    "Eosinophils_Aggregate3" = "Eosinophils"
)


#####


parser = ArgumentParser(
    description = "Combine Cibersort cell types into aggregates"
)

parser$add_argument(
    "-c",
    "--cibersort_file",
    type = "character",
    required = TRUE
)
parser$add_argument(
    "-o",
    "--output_file",
    type = "character",
    default = "output.tsv"
)

args <- parser$parse_args()

cibersort_df <- args$cibersort_file %>%
    readr::read_tsv(.) %>% 
    dplyr::select(c("Mixture", CIBERSORT_CELLTYPES)) %>% 
    tidyr::gather(key = "celltype", value = "fraction", -Mixture) %>%
    dplyr::mutate(celltype = stringr::str_replace_all(celltype, " ", "_")) %>% 
    dplyr::mutate(celltype = stringr::str_remove_all(celltype, "[\\)\\(]")) %>% 
    tidyr::spread(., key = "celltype", value = "fraction") %>% 
    dplyr::rename("sample" = "Mixture")

    
for (new_column in names(AGGREGATE_LIST)) {
    row_sums <- cibersort_df %>%
        dplyr::select(AGGREGATE_LIST[[new_column]]) %>%
        rowSums
    cibersort_df <- magrittr::inset(cibersort_df, new_column, value = row_sums)
}

write_tsv(cibersort_df, args$output_file)






