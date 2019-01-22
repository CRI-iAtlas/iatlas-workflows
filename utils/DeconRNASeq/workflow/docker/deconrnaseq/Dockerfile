FROM rocker/tidyverse

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('BiocManager')"

RUN Rscript -e "BiocManager::install('DeconRNASeq', version = '3.8')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
