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
    "Lymphocytes.Aggregate1" = c(
        "B.cells.naive",
        "B.cells.memory",
        "T.cells.CD4.naive",
        "T.cells.CD4.memory.resting", 
        "T.cells.CD4.memory.activated",
        "T.cells.follicular.helper",
        "T.cells.regulatory..Tregs",
        "T.cells.gamma.delta",
        "T.cells.CD8",
        "NK.cells.resting",
        "NK.cells.activated",
        "Plasma.cells"
    ),
    
    "Neutrophils.Aggregate1" = "Neutrophils",
    "Eosinophils.Aggregate1" = "Eosinophils",
    "Mast.cells.Aggregate1"  = c("Mast.cells.resting", "Mast.cells.activated"),
    "Dendritic.cells.Aggregate1" = c(
        "Dendritic.cells.resting", 
        "Dendritic.cells.activated"
    ),
    "Macrophage.Aggregate1" = c(
        "Monocytes",
        "Macrophages.M0", 
        "Macrophages.M1",
        "Macrophages.M2"
    ),
    
    "Neutrophils.Aggregate2" = "Neutrophils",
    "Eosinophils.Aggregate2" = "Eosinophils",
    "Mast.cells.Aggregate2" = c("Mast.cells.resting", "Mast.cells.activated"),
    "Dendritic.cells.Aggregate2" = c(
        "Dendritic.cells.resting", 
        "Dendritic.cells.activated"
    ),
    
    "Macrophage.Aggregate2" = c("Macrophages.M0", "Macrophages.M1", "Macrophages.M2"),
    "NK.cells.Aggregate2" = c("NK.cells.resting", "NK.cells.activated"),
    "B.cells.Aggregate2" = c("B.cells.naive",  "B.cells.memory"),
    "T.cells.CD8.Aggregate2" = "T.cells.CD8",
    "T.cells.CD4.Aggregate2" = c(
        "T.cells.CD4.naive",
        "T.cells.CD4.memory.resting",
        "T.cells.CD4.memory.activated"
    ),

    "B.cells.Aggregate3" = c("B.cells.naive", "B.cells.memory"),
    "Plasma.cells.Aggregate3" = "Plasma.cells",
    "T.cells.CD8.Aggregate3" = "T.cells.CD8",
    "T.cells.CD4.Aggregate3" = c(
        "T.cells.CD4.naive",
        "T.cells.CD4.memory.resting",
        "T.cells.CD4.memory.activated",
        "T.cells.follicular.helper", 
        "T.cells.regulatory..Tregs"),
    "T.cells.gamma.delta.Aggregate3" = "T.cells.gamma.delta",
    "NK.cells.Aggregate3" = c("NK.cells.resting", "NK.cells.activated"),
    "Macrophage.Aggregate3" = c(
        "Monocytes", 
        "Macrophages.M0", 
        "Macrophages.M1", 
        "Macrophages.M2"),
    
    "Dendritic.cells.Aggregate3" = c(
        "Dendritic.cells.resting",
        "Dendritic.cells.activated"
    ),
    
    "Mast.cells.Aggregate3" = c("Mast.cells.resting", "Mast.cells.activated"),
    "Neutrophils.Aggregate3" = "Neutrophils",
    "Eosinophils.Aggregate3" = "Eosinophils"
)


#####


parser = ArgumentParser(description = "Combine Cibersort cell types into aggregates")

parser$add_argument(
    "-c",
    "--cibersort_file",
    type = "character",
    required = TRUE)
parser$add_argument(
    "-o",
    "--output_file",
    type = "character",
    default = "output.tsv")


args <- parser$parse_args()

cibersort_df <- args$cibersort_file %>%
    readr::read_tsv() %>% 
    dplyr::select(c("Mixture", CIBERSORT_CELLTYPES)) %>% 
    tidyr::gather(key = "celltype", value = "fraction", - Mixture) %>%
    dplyr::mutate(celltype = stringr::str_replace_all(celltype, "[ \\(]", "\\.")) %>% 
    dplyr::mutate(celltype = stringr::str_remove_all(celltype, "\\)")) %>% 
    tidyr::spread(key = "celltype", value = "fraction") %>% 
    dplyr::rename("sample" = "Mixture")


for (new_column in names(AGGREGATE_LIST)) {
    row_sums <- cibersort_df %>%
        dplyr::select(AGGREGATE_LIST[[new_column]]) %>%
        rowSums
    cibersort_df <- inset(cibersort_df, new_column, value = row_sums)
}

write_tsv(cibersort_df, args$output_file)






