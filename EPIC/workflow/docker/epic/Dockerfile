FROM ubuntu:16.04

RUN apt-get update
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN apt-get update
RUN apt-get -y install r-base git libcurl4-openssl-dev libssl-dev

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages('argparse')"
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "install.packages('curl')"
RUN Rscript -e "library(devtools);devtools:::install_github('GfellerLab/EPIC', ref = 'v1.1')"

COPY bin/epic.R /usr/local/bin/
RUN chmod a+x /usr/local/bin/epic.R
