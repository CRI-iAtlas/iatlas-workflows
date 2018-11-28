library(curl)
library(MCPcounter)
library(readr)
library(magrittr)
library(tibble)

expression_df <- MCPcounter::MCPcounterExampleData %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("gene") 

write_tsv(expression_df, "../sample_expression.tsv")

expression_df %>% 
    tibble::column_to_rownames("gene") %>% 
    as.matrix() %>% 
    MCPcounter::MCPcounter.estimate(featuresType = "affy133P2_probesets") %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("cell_type") %>% 
    write_tsv("../sample_output.tsv")
    
    