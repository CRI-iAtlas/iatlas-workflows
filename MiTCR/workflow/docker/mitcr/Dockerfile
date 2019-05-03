FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install -y default-jre 

WORKDIR /home/ubuntu/

RUN wget https://github.com/milaboratory/mitcr/releases/download/1.0.3/mitcr-1.0.3.jar

RUN chmod +x mitcr-1.0.3.jar