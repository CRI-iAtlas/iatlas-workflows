FROM rocker/tidyverse

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('clue')"
RUN Rscript -e "install.packages('mclust')"

RUN Rscript -e "install.packages('BiocManager')"
RUN Rscript -e "BiocManager::install('sva', version = '3.8')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
