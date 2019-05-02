FROM ubuntu:18.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 zlib1g-dev \
 cmake \
 libhdf5-dev \
 git-all \
 autoconf \
 automake \
 libcurl4-openssl-dev

# Get latest source from releases
WORKDIR /opt
RUN git clone https://github.com/pachterlab/kallisto.git
WORKDIR kallisto
RUN git clone https://github.com/samtools/htslib
RUN rm -rf -f build
RUN rm -rf /ext/htslib
RUN cp -r htslib /ext/
WORKDIR /opt/kallisto/ext/htslib
RUN autoconf && autoheader
WORKDIR /opt/kallisto
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make
RUN make install

COPY Dockerfile /opt/.

