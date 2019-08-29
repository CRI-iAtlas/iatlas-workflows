FROM rocker/tidyverse:3.6.1 

RUN Rscript -e "install.packages('argparse')"

RUN Rscript -e "library(devtools);devtools::install_github('GfellerLab/EPIC', ref = 'v1.1')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
