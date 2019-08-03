FROM python:3.7

RUN pip3 install argparse
RUN pip3 install biopython

COPY bin/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*
