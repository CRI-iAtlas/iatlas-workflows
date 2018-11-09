FROM bioconductor/release_core2

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "source('https://bioconductor.org/biocLite.R');biocLite('DeconRNASeq')"

COPY bin/deconrnaseq.R /usr/local/bin/
RUN chmod a+x /usr/local/bin/deconrnaseq.R
