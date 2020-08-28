synapser::synLogin()

label_tbl <- "syn21783989" %>% 
    synapser::synGet() %>% 
    purrr::pluck("path") %>% 
    feather::read_feather(.) %>% 
    dplyr::select("node" = "Obj", "label" = "Type") 

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

hgnc_translation1 <- label_tbl %>% 
    dplyr::select("node") %>% 
    dplyr::distinct() %>% 
    dplyr::inner_join(genes, by = c("node" = "hgnc")) %>% 
    dplyr::rename("new_node" = "entrez")

hgnc_translation2 <- label_tbl %>% 
    dplyr::filter(!node %in% c(hgnc_translation1$node, cell_features)) %>% 
    dplyr::select("node") %>% 
    dplyr::distinct() %>% 
    dplyr::inner_join(tcga_genes, by = c("node" = "hgnc")) %>% 
    dplyr::rename("new_node" = "entrez")

cell_translation <- label_tbl %>% 
    dplyr::filter(node %in% c(cell_features)) %>% 
    dplyr::select("node") %>% 
    dplyr::distinct() %>% 
    dplyr::mutate("new_node" = stringr::str_c(node, "_Aggregate2"))

translation <- 
    dplyr::bind_rows(
        hgnc_translation1, hgnc_translation2, cell_translation
    ) 

new_tbl <- label_tbl %>% 
    dplyr::inner_join(translation) %>% 
    dplyr::select(-node) %>% 
    dplyr::rename(node = new_node)

feather::write_feather(
    new_tbl, 
    "Network_Analysis/workflow/examples/fantom_entrez/node_labels.feather"
)
    
