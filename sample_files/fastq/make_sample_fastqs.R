# requires fastq-tools: https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-sample.html
# requires permissions to synapse entities: https://www.synapse.org/#!Synapse:syn12649849

library(synapser)
library(tidyverse)
library(magrittr)

synapser::synLogin()

p1_fastq_id <- "syn13855840"
p2_fastq_id <- "syn13855885"

p1_path <- p1_fastq_id %>% 
    synapser::synGet(downloadLocation = ".") %>% 
    magrittr::use_series(path)

p2_path <- p2_fastq_id %>% 
    synapser::synGet(downloadLocation = ".") %>% 
    magrittr::use_series(path)

stringr::str_c("gunzip ", p1_path) %>% 
    system

stringr::str_c("gunzip ", p2_path) %>% 
    system

new_names <- 
    c(p1_path, p2_path) %>% 
    basename() %>% 
    stringr::str_remove_all(".gz")

new_names %>% 
    stringr::str_c(collapse = " ") %>% 
    stringr::str_c("fastq-sample -n 10000 −s 1", .) %>% 
    system

file.remove(new_names)
    

