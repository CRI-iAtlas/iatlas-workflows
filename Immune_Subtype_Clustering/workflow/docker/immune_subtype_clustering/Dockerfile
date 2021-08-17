FROM rocker/tidyverse:4.1.0 

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "devtools::install_github('Gibbsdavidl/ImmuneSubtypeClassifier', ref = 'v0.1.1')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
