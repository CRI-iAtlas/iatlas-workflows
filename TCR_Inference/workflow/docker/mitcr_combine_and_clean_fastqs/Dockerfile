FROM ubuntu:16.04

RUN apt-get update
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN apt-get update
RUN apt-get -y install wget python

WORKDIR /home/ubuntu/

RUN wget https://raw.githubusercontent.com/scottdbrown/TCR-from-RNAseq2015/12a9778aa38fd07757cd6a8d3d33806e42431d76/combineAndCleanFastq.py

RUN chmod +x combineAndCleanFastq.py