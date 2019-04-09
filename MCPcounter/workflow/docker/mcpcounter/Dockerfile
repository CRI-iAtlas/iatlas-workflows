FROM rocker/tidyverse

RUN Rscript -e "install.packages('argparse')"

RUN Rscript -e "library(devtools);devtools::install_github('ebecht/MCPcounter', ref = 'a79614eee002c88c64725d69140c7653e7c379b4', subdir = 'Source')"

COPY bin/mcpcounter.R /usr/local/bin/
RUN chmod a+x /usr/local/bin/mcpcounter.R
