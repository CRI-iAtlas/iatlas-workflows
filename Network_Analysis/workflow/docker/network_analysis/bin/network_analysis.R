library(abcnet)
library(argparse)

parser = argparse::ArgumentParser()

# required args

parser$add_argument(
    "-e",
    "--input_expression_files",
    type = "character",
    required = TRUE,
    nargs = "+"
)

parser$add_argument(
    "-c",
    "--input_celltype_files",
    type = "character",
    required = TRUE,
    nargs = "+"
)

parser$add_argument(
    "-g",
    "--input_group_files",
    type = "character",
    required = TRUE,
    nargs = "+"
)

parser$add_argument(
    "--input_scaffold_file",
    type = "character",
    required = TRUE
)

# optional args

parser$add_argument(
    "--input_node_label_file",
    type = "character",
    default = NULL
)

parser$add_argument(
    "--output_nodes_file",
    type = "character",
    default = "output_nodes.feather"
)

parser$add_argument(
    "--output_edges_file",
    type = "character",
    default = "output_edges.feather"
)

parser$add_argument(
    "--input_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--output_file_type",
    type = "character",
    default = "feather"
)

parser$add_argument(
    "--group_sample_col",
    type = "character",
    default = "sample"
)

parser$add_argument(
    "--group_name_cols",
    type = "character",
    default = "group",
    nargs = "+"
)

parser$add_argument(
    "--group_name_seperator",
    type = "character",
    default = ":"
)

parser$add_argument(
    "--expression_sample_col",
    type = "character",
    default = "sample"
)

parser$add_argument(
    "--expression_value_col",
    type = "character",
    default = "expression"
)

parser$add_argument(
    "--expression_node_col",
    type = "character",
    default = "node"
)

parser$add_argument(
    "--celltype_value_col",
    type = "character",
    default = "value"
)

parser$add_argument(
    "--celltype_sample_col",
    type = "character",
    default = "sample"
)

parser$add_argument(
    "--celltype_node_col",
    type = "character",
    default = "node"
)

parser$add_argument(
    "--scaffold_from_col",
    type = "character",
    default = "from"
)

parser$add_argument(
    "--scaffold_to_col",
    type = "character",
    default = "to"
)

parser$add_argument(
    "--min_group_size",
    type = "integer",
    default = 3L
)

parser$add_argument(
    "--add_noise",
    action = "store_true"
)

parser$add_argument(
    "--log_expression",
    action = "store_true"
)

args <- parser$parse_args()

if(args$input_file_type == "feather") {
    read_func <- feather::read_feather
} else if(args$input_file_type == "csv") {
    read_func <- readr::read_csv
} else if(args$input_file_type == "tsv") {
    read_func <- readr::read_tsv
} else {
    stop("Unsupported input file type")
}

if(args$output_file_type == "feather") {
    write_func <- feather::write_feather
} else if(args$input_file_type == "csv") {
    write_func <- readr::write_csv
} else if(args$input_file_type == "tsv") {
    write_func <- readr::write_tsv
} else {
    stop("Unsupported output file type")
}

group_tbl <- args$input_group_files %>% 
    purrr::map(read_func) %>%
    dplyr::bind_rows() %>% 
    tidyr::unite(
        "group",
        args$group_name_cols,
        sep = args$group_name_seperator
    ) %>%
    dplyr::select(
        "sample" = args$group_sample_col,
        "group"
    ) %>%
    tidyr::drop_na() 


expression_tbl <- args$input_expression_files %>% 
    purrr::map(read_func) %>%
    dplyr::bind_rows() %>% 
    dplyr::select(
        "sample" = args$expression_sample_col,
        "node"   = args$expression_node_col,
        "value"  = args$expression_value_col
    ) %>% 
    dplyr::mutate("node" = as.character(.data$node)) %>% 
    tidyr::drop_na()

celltype_tbl <- args$input_celltype_files %>% 
    purrr::map(read_func) %>%
    dplyr::bind_rows() %>% 
    dplyr::select(
        "sample" = args$celltype_sample_col,
        "node"   = args$celltype_node_col,
        "value"  = args$celltype_value_col
    ) %>% 
    dplyr::mutate("node" = as.character(.data$node)) %>% 
    tidyr::drop_na()

genes <- unique(expression_tbl$node)
cells <- unique(celltype_tbl$node) 

scaffold_all_cols <- args$input_scaffold_file %>% 
    read_func() %>% 
    dplyr::rename(
        "From" = args$scaffold_from_col,
        "To"   = args$scaffold_to_col
    ) 

scaffold <- scaffold_all_cols %>% 
    dplyr::select("From", "To") %>%
    tidyr::drop_na() %>% 
    abcnet::get_scaffold(., cells, genes) 

if (args$log_expression) {
    expression_tbl <- expression_tbl %>% 
        dplyr::mutate("value" = log2(.data$value + 1)) %>% 
        tidyr::drop_na()
}

if(!is.null(args$input_node_label_file)){
    node_label_tbl <- args$input_node_label_file %>% 
        read_func() %>% 
        dplyr::select("Node" = "node", "label") 
} else {
    node_label_tbl <- NULL 
}


node_tbl <- 
    dplyr::bind_rows(expression_tbl, celltype_tbl) %>% 
    dplyr::inner_join(group_tbl, by = "sample") %>% 
    dplyr::add_count(.data$group) %>% 
    dplyr::filter(.data$n >= args$min_group_size) %>% 
    dplyr::select(-"n")

if (args$add_noise) {
    node_tbl <- dplyr::mutate(
        node_tbl,
        "value" = .data$value + rnorm(mean = 0, sd = 0.0001, dplyr::n())
    )
}

nodes_scores <- abcnet::compute_abundance(
    dfn   = node_tbl, 
    node  = "node", 
    ids   = "sample", 
    exprv = "value", 
    group = "group", 
    cois  = cells, 
    gois  = genes
) 
    
abundance_scores <- nodes_scores %>% 
    abcnet::get_abundance_table(.) 

if(nrow(abundance_scores) == 0) stop("No abundance scores calculated")

abundance_tbl <-abundance_scores %>% 
    tidyr::separate(
        "Group", args$group_name_cols, sep = args$group_name_seperator
    ) 

if(!is.null(node_label_tbl)){
    abundance_tbl <- dplyr::left_join(
        abundance_tbl, node_label_tbl, by = "Node"
    )
}

write_func(abundance_tbl, args$output_nodes_file)
    


edges_scores <- nodes_scores %>% 
    abcnet::compute_concordance(scaffold, .)

if(nrow(edges_scores) == 0) stop("No concordance scores calculated")

edges_scores %>% 
    tidyr::separate(
        "Group", args$group_name_cols, sep = args$group_name_seperator
    ) %>% 
    dplyr::inner_join(scaffold_all_cols, by = c("From", "To")) %>% 
    write_func(args$output_edges_file)
