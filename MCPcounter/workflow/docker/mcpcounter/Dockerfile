FROM rocker/tidyverse:3.6.1 

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "library(devtools);devtools::install_github('ebecht/MCPcounter', ref = 'a79614eee002c88c64725d69140c7653e7c379b4', subdir = 'Source')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
