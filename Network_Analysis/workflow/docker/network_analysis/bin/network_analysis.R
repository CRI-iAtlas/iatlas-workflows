library(abcnet)
library(dplyr)
library(argparse)

parser = ArgumentParser()

# required args

parser$add_argument(
    "-e",
    "--expression_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "-c",
    "--celltype_file",
    type = "character",
    required = TRUE
)

# optional args

parser$add_argument(
    "--scaffold_file",
    type = "character",
    default = "/usr/local/bin/fantom_scaffold.tsv"
)

parser$add_argument(
    "--expression_file_delimeter",
    type = "character",
    default = "\t"
)

parser$add_argument(
    "--celltype_file_delimeter",
    type = "character",
    default = "\t"
)

parser$add_argument(
    "--scaffold_file_delimeter",
    type = "character",
    default = "\t"
)

parser$add_argument(
    "--sample_col",
    type = "character",
    default = "sample"
)

parser$add_argument(
    "--gene_col",
    type = "character",
    default = "gene"
)

parser$add_argument(
    "--expression_col",
    type = "character",
    default = "expression"
)

parser$add_argument(
    "--group_col",
    type = "character",
    default = "group"
)

parser$add_argument(
    "--cell_col",
    type = "character",
    default = "cell"
)

parser$add_argument(
    "--fraction_col",
    type = "character",
    default = "fraction"
)

parser$add_argument(
    "--from_col",
    type = "character",
    default = "From"
)

parser$add_argument(
    "--to_col",
    type = "character",
    default = "To"
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

expression_tbl <- args$expression_file %>% 
    readr::read_delim(., delim = args$expression_file_delimeter) %>% 
    dplyr::select(
        "sample" = args$sample_col,
        "node"   = args$gene_col,
        "value"  = args$value_col,
        "group"  = args$group_col
    ) %>% 
    tidyr::drop_na()

if (args$log_expression) {
    expression_tbl <- expression_tbl %>% 
        dplyr::mutate(value = log2(value + 1)) %>% 
        tidyr::drop_na()
}

genes <- unique(expression_tbl$node)

celltype_tbl <- args$celltype_file %>% 
    readr::read_delim(., delim = args$expression_file_delimeter) %>% 
    dplyr::select(
        "sample" = args$sample_col,
        "node"   = args$cell_col,
        "value"  = args$fraction_col,
        "group"  = args$group_col
    ) %>% 
    tidyr::drop_na()


cells <- unique(celltype_tbl$node) 

node_tbl <- dplyr::bind_rows(expression_tbl, celltype_tbl) 

if (args$add_noise) {
    node_tbl <- node_tbl %>% 
        dplyr::mutate(value = value + rnorm(mean = 0, sd = 0.0001, nrow(.)))
}

scaffold <- args$scaffold_file %>% 
    readr::read_delim(., delim = args$scaffold_file_delimeter) %>% 
    dplyr::select(
        "From" = args$from_col,
        "To"   = args$to_col
    ) %>% 
    tidyr::drop_na() %>% 
    abcnet::get_scaffold(., cells, genes)

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

readr::write_tsv(abundance_scores, args$nodes_file)
readr::write_tsv(edges_scores, args$edges_file)