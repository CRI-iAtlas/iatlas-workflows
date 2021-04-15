FROM rocker/tidyverse:4.0.3

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('arrow')"

RUN Rscript -e "library(devtools);devtools::install_github('heimannch/abcnet', ref = '17907bc4ad112eb9bdebac000d50e5f9217deed7')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
