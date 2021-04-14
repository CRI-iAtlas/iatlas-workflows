FROM rocker/tidyverse:3.6.1 

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "library(devtools);devtools::install_github('ebecht/MCPcounter', ref = 'b6eac73e91c246fcff0bb1a5c68a816cd588fc48', subdir = 'Source')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
