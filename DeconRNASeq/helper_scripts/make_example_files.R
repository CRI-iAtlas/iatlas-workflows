library(DeconRNASeq)
library(readr)
library(tibble)
library(magrittr)

# multi_tissue: expression profiles for 10 mixing samples from
# multiple tissues
data(multi_tissue)

datasets <- x.data %>% 
    .[,2:11] %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("gene") %>% 
    readr::write_tsv('../sample_expression.tsv')
    
signatures  <- x.signature.filtered.optimal %>% 
    .[,2:6] %>% 
    as.data.frame() %>% 
    tibble::rownames_to_column("gene") %>% 
    readr::write_tsv('../sample_signatures.tsv')