library(curl)
library(MCPcounter)
library(readr)
library(magrittr)
library(tibble)

expression_df <- MCPcounter::MCPcounterExampleData %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("gene") 

write_tsv(expression_df, "../sample_expression.tsv")