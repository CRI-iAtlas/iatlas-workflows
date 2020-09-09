FROM rocker/tidyverse:4.0.2

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('feather')"
RUN Rscript -e "install.packages('immunarch')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
