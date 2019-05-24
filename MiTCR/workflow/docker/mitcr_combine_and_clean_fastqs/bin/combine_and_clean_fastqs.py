'''
Created February 5, 2016

@author: sbrown

This script ensures that every read to be used as input for MiTCR is only comprised of ACTGN, and ensures reads are at least 40 bases long.
Input: Path to directory containing fastq files to process.

Python requirements: v2.x.x

Modified by Andrew Lamb May 24, 2019

'''

import re
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('fastqs', nargs='+')
args = parser.parse_args()

i = 0
block = ""
valid = True
reg = re.compile('^[ACTGN]+$')


numReads = 0


reads = open("reads.fq", "w")

for f in args.fastqs:
    if (f.endswith(".fastq") or f.endswith(".fq")) and f != "reads.fq":
         for line in open(f, "r"):
             i += 1
             block += line.rstrip() + "\t"
             if i == 2:
                 if(reg.match(line.upper()) and len(line)>40):
                     valid = True
                 else:
                     valid = False
             elif i == 4 and valid:
                 reads.write(block.replace("\t","\n"))   # cleaves off trailing \t
                 block = ""
                 i = 0
                 numReads += 1
             elif i == 4 and not valid:
                 block = ""
                 i = 0

reads.close()

