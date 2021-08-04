FROM rocker/tidyverse:4.1.0 

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('arrow')"

RUN Rscript -e "library(devtools);devtools::install_github('CRI-iAtlas/iatlas.api.client', ref = '0.24.1')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
