FROM rocker/tidyverse

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('sva')"
RUN Rscript -e "install.packages('clue')"
RUN Rscript -e "install.packages('mclust')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
