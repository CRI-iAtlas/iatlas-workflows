synapser::synLogin()

"syn21783989" %>% 
    synapser::synGet() %>% 
    purrr::pluck("path") %>% 
    feather::read_feather(.) %>% 
    dplyr::select("node" = "Obj", "label" = "Type") %>% 
    readr::write_tsv(., "Network_Analysis/workflow/examples/fantom_hgnc/node_labels.tsv")
    
