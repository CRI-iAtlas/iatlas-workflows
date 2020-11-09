FROM rocker/tidyverse:4.0.2

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('arrow')"

RUN Rscript -e "library(devtools);devtools::install_github('heimannch/abcnet', ref = 'fe0144c4649a7c7dc11299b69a69b68c91c802d9')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
