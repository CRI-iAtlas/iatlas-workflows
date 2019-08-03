from Bio.SeqIO.QualityIO import FastqGeneralIterator
import gzip
import re
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--fastqs', nargs='+')
parser.add_argument('-o', '--output_file', default = "reads.fq", nargs='?')
args = parser.parse_args()


reg = re.compile('^[ACTGN]+$')

with open(args.output_file, "w") as out_handle:
    for file in args.fastqs:
        if file.endswith(".gz"):
            open_func = gzip.open
        else:
            open_func = open   
            
        with open_func(file, "rt") as in_handle:
            for title, seq, qual in FastqGeneralIterator(in_handle):
                if(reg.match(seq.upper()) and len(seq) > 40):
                    out_handle.write("@%s\n%s\n+\n%s\n" % (title, seq, qual))

