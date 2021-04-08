FROM rocker/tidyverse:4.0.2 

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('arrow')"

RUN Rscript -e "library(devtools);devtools::install_github('CRI-iAtlas/iatlas.api.client', ref = '0.13.1')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
