synapser::synLogin()


tcga_genes <- "syn22133677" %>% 
    synapser::synGet() %>% 
    purrr::pluck("path") %>% 
    feather::read_feather(.) %>% 
    tidyr::drop_na() %>% 
    dplyr::mutate("entrez" = as.character(entrez))

genes <- "syn22240716" %>% 
    synapser::synGet() %>% 
    purrr::pluck("path") %>% 
    feather::read_feather(.) %>% 
    tidyr::drop_na() %>% 
    dplyr::mutate("entrez" = as.character(entrez))

cell_features <- c(
    "B_cells",
    "Dendritic_cells",
    "Eosinophils",
    "Macrophage",
    "Mast_cells",
    "NK_cells",
    "Neutrophils",
    "T_cells_CD4",
    "T_cells_CD8"
)

hgnc_scaffold <- "Network_Analysis/workflow/examples/fantom_hgnc/fantom_scaffold.tsv" %>% 
    readr::read_tsv() %>%  
    dplyr::mutate("number" = 1:dplyr::n()) %>% 
    tidyr::pivot_longer(-"number")

hgnc_translation1 <- hgnc_scaffold %>% 
    dplyr::select("value") %>% 
    dplyr::distinct() %>% 
    dplyr::inner_join(genes, by = c("value" = "hgnc")) %>% 
    dplyr::rename("new_value" = "entrez")

hgnc_translation2 <- hgnc_scaffold %>% 
    dplyr::filter(!value %in% c(hgnc_translation1$value, cell_features)) %>% 
    dplyr::select("value") %>% 
    dplyr::distinct() %>% 
    dplyr::inner_join(tcga_genes, by = c("value" = "hgnc")) %>% 
    dplyr::rename("new_value" = "entrez")

cell_translation <- 
    hgnc_scaffold %>% 
    dplyr::filter(value %in% c(cell_features)) %>% 
    dplyr::select("value") %>% 
    dplyr::distinct() %>% 
    dplyr::mutate("new_value" = stringr::str_c(value, "_Aggregate2"))

translation <- 
    dplyr::bind_rows(
        hgnc_translation1, hgnc_translation2, cell_translation
    ) 

entrez_scaffold <- hgnc_scaffold %>% 
    dplyr::inner_join(translation) %>% 
    dplyr::select(-value) %>% 
    dplyr::rename(value = new_value) %>% 
    tidyr::pivot_wider() %>% 
    tidyr::drop_na() %>% 
    dplyr::select(-number)

feather::write_feather(
    entrez_scaffold, 
    "Network_Analysis/workflow/examples/fantom_entrez/fantom_scaffold.tsv"
)
