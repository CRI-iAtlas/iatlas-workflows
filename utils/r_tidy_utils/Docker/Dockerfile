FROM rocker/tidyverse:4.0.2

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('arrow')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
