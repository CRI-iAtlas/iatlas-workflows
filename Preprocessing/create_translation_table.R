library(biomaRt)
library(magrittr)
library(dplyr)

translation_df <- 
    biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl") %>% 
    biomaRt::getBM(
        attributes = c("ensembl_transcript_id", "hgnc_symbol"),
        mart = .) %>% 
    magrittr::set_colnames(c("transcript", "Hugo")) %>% 
    dplyr::filter(Hugo != "")

write_tsv(translation_df, "translation.tsv")
