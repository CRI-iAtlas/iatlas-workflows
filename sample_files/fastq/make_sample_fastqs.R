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

system("fastq-sample -n 40000 SRR1740086_1.fastq SRR1740086_2.fastq")
