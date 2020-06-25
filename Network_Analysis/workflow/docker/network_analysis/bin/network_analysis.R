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
    "--cell_abundance_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "-g",
    "--group_file",
    type = "character",
    required = TRUE
)

parser$add_argument(
    "--scaffold_file",
    type = "character",
    required = TRUE
)

# optional args

parser$add_argument(
    "--nodes_output_file",
    type = "character",
    default = "nodes.tsv"
)

parser$add_argument(
    "--edges_output_file",
    type = "character",
    default = "edges.tsv"
)

parser$add_argument(
    "--group_file_delimeter",
    type = "character",
    default = "\t"
)

parser$add_argument(
    "--expression_file_delimeter",
    type = "character",
    default = "\t"
)

parser$add_argument(
    "--cell_abundance_file_delimeter",
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

# args <- list(
#     "group_file" = "Network_Analysis/workflow/examples/one/groups.tsv",
#     "expression_file" = "Network_Analysis/workflow/examples/one/expression.tsv",
#     "celltype_file" = "Network_Analysis/workflow/examples/one/cells.tsv",
#     "scaffold_file" = "Network_Analysis/workflow/examples/one/scaffold.tsv",
#     "nodes_output_file" = "Network_Analysis/workflow/examples/one/nodes.tsv",
#     "edges_output_file" = "Network_Analysis/workflow/examples/one/edges.tsv",
#     "group_file_delimeter" = "\t",
#     "expression_file_delimeter" = "\t",
#     "celltype_file_delimeter" = "\t",
#     "scaffold_file_delimeter" = "\t",
#     "sample_col" = "sample",
#     "gene_col" = "gene",
#     "expression_col" = "expression",
#     "group_col" = "group",
#     "cell_col" = "cell",
#     "fraction_col" = "fraction",
#     "from_col" = "From",
#     "to_col" = "To",
#     "add_noise" = T,
#     "log_expression" = T
# )

group_tbl <- args$group_file %>% 
    readr::read_delim(., delim = args$group_file_delimeter) %>% 
    dplyr::select(
        "sample" = args$sample_col,
        "group"  = args$group_col
    ) %>% 
    tidyr::drop_na()

expression_tbl <- args$expression_file %>% 
    readr::read_delim(., delim = args$expression_file_delimeter) %>% 
    dplyr::select(
        "sample" = args$sample_col,
        "node"   = args$gene_col,
        "value"  = args$expression_col
    ) %>% 
    tidyr::drop_na()

celltype_tbl <- args$cell_abundance_file %>% 
    readr::read_delim(., delim = args$cell_abundance_file_delimeter) %>% 
    dplyr::select(
        "sample" = args$sample_col,
        "node"   = args$cell_col,
        "value"  = args$fraction_col
    ) %>% 
    tidyr::drop_na()

genes <- unique(expression_tbl$node)
cells <- unique(celltype_tbl$node) 

scaffold <- args$scaffold_file %>% 
    readr::read_delim(., delim = args$scaffold_file_delimeter) %>% 
    dplyr::select(
        "From" = args$from_col,
        "To"   = args$to_col
    ) %>% 
    tidyr::drop_na() %>% 
    abcnet::get_scaffold(., cells, genes)

if (args$log_expression) {
    expression_tbl <- expression_tbl %>% 
        dplyr::mutate(value = log2(value + 1)) %>% 
        tidyr::drop_na()
}

node_tbl <- 
    dplyr::bind_rows(expression_tbl, celltype_tbl) %>% 
    dplyr::inner_join(group_tbl, by = "sample")

if (args$add_noise) {
    node_tbl <- node_tbl %>% 
        dplyr::mutate(value = value + rnorm(mean = 0, sd = 0.0001, nrow(.)))
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

readr::write_tsv(abundance_scores, args$nodes_output_file)
readr::write_tsv(edges_scores, args$edges_output_file)
