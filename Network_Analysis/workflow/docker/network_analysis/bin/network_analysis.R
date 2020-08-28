library(abcnet)
library(dplyr)
library(argparse)

parser = argparse::ArgumentParser()

# required args

parser$add_argument(
    "-e",
    "--input_expression_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "-c",
    "--input_celltype_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "-g",
    "--input_group_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--input_scaffold_file",
    type = "character",
    required = TRUE
)

# optional args

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
    "--group_name_col",
    type = "character",
    default = "group"
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

group_tbl <- args$input_group_file %>% 
    read_func() %>% 
    dplyr::select(
        "sample" = args$group_sample_col,
        "group"  = args$group_name_col
    ) %>% 
    tidyr::drop_na() 


expression_tbl <- args$input_expression_file %>% 
    read_func() %>% 
    dplyr::select(
        "sample" = args$expression_sample_col,
        "node"   = args$expression_node_col,
        "value"  = args$expression_value_col
    ) %>% 
    dplyr::mutate("node" = as.character(.data$node)) %>% 
    tidyr::drop_na()

celltype_tbl <- args$input_celltype_file %>% 
    read_func() %>% 
    dplyr::select(
        "sample" = args$celltype_sample_col,
        "node"   = args$celltype_node_col,
        "value"  = args$celltype_value_col
    ) %>% 
    dplyr::mutate("node" = as.character(.data$node)) %>% 
    tidyr::drop_na()

genes <- unique(expression_tbl$node)
cells <- unique(celltype_tbl$node) 

scaffold <- args$input_scaffold_file %>% 
    read_func() %>% 
    dplyr::select(
        "From" = args$scaffold_from_col,
        "To"   = args$scaffold_to_col
    ) %>% 
    tidyr::drop_na() %>% 
    abcnet::get_scaffold(., cells, genes)

if (args$log_expression) {
    expression_tbl <- expression_tbl %>% 
        dplyr::mutate("value" = log2(.data$value + 1)) %>% 
        tidyr::drop_na()
}

node_tbl <- 
    dplyr::bind_rows(expression_tbl, celltype_tbl) %>% 
    dplyr::inner_join(group_tbl, by = "sample") 

if (args$add_noise) {
    node_tbl <- dplyr::mutate(
        node_tbl,
        "value" = .data$value + rnorm(mean = 0, sd = 0.0001, dplyr::n())
    )
}

#Computing nodes scores
nodes_scores <- abcnet::compute_abundance(
    dfn   = node_tbl, 
    node  = "node", 
    ids   = "sample", 
    exprv = "value", 
    group = "group", 
    cois  = cells, 
    gois  = genes
) 
    
#Organizing the scores in a table
abundance_scores <- abcnet::get_abundance_table(nodes_scores)

#Computing edges scores
edges_scores <- abcnet::compute_concordance(scaffold, nodes_scores)

write_func(abundance_scores, args$output_nodes_file)
write_func(edges_scores, args$output_edges_file)
