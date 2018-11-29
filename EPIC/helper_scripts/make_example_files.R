library(EPIC)
library(readr)
library(tibble)
library(magrittr)

expression_df <- melanoma_data %>% 
    magrittr::use_series(counts) %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("gene") %>% 
    readr::write_tsv("../sample_expression.tsv")