FROM rocker/tidyverse:3.6.1

RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "devtools::install_github('Gibbsdavidl/ImmuneSubtypeClassifier', ref = '30e6215c390bf12761d17cbc9647ac4527e319ba')"

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.R
