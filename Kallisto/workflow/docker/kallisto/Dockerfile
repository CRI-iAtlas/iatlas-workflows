FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget

RUN cd ~/ && wget https://github.com/pachterlab/kallisto/releases/download/v0.45.1/kallisto_linux-v0.45.1.tar.gz && \
    tar -xzvf kallisto_linux-v0.45.1.tar.gz && rm kallisto_linux-v0.45.1.tar.gz && \
    echo 'PATH="$PATH:$HOME/kallisto_linux-v0.45.1"' >> ~/.bashrc

