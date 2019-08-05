import argparse
import math
import json
from itertools import islice
from collections import namedtuple
from dataclasses import dataclass

SequenceReads = namedtuple('sequence_reads', 'chain_type n_reads')


@dataclass
class Result:
    sample: str
    total_TCR: int
    alpha_chain_TCR: int
    beta_chain_TCR: int
    TCR_Shannon: float
    TCR_Richness: int
    TCR_Evenness: float

def main(alpha_chain_file, beta_chain_file, output_file, sample_name):
    sequence_reads = combine_cdr3_reads(alpha_chain_file, beta_chain_file)
    result = calculate_statistics(sequence_reads, sample_name)
    
    if(output_file == "use_sample_name"):
        output_json = sample_name + ".json"
    else:
        output_json = output_file

    with open(output_json, 'w') as json_file:
        json.dump(vars(result), json_file)
    

def combine_cdr3_reads(alpha_chain_file, beta_chain_file):
    cdr3_dict = add_cdr3_reads({}, alpha_chain_file, "alpha")
    cdr3_dict = add_cdr3_reads(cdr3_dict, beta_chain_file, "beta")
    return(cdr3_dict.values())

    
def add_cdr3_reads(cdr3_dict, cdr3_file, chain_type):
    with open(cdr3_file, 'r') as f:
        for line in islice(f, 2, None):
            (n_reads, _, seq, _, _, aa_seq,
             *rest) = tuple(line.rstrip().split("\t"))
            n_reads = int(n_reads)
            if all(char not in aa_seq for char in ["*", "~"]):
                if seq not in cdr3_dict:
                    cdr3_dict[seq] = SequenceReads(chain_type, n_reads)
                else:
                    if n_reads > cdr3_dict[seq].n_reads:
                        cdr3_dict[seq] = SequenceReads(chain_type, n_reads)
                    elif n_reads == cdr3_dict[seq].n_reads:
                        cdr3_dict[seq] = SequenceReads("ambiguous", n_reads)
    return(cdr3_dict)


def calculate_statistics(sequence_reads, sample_name):
    reads_list = [seq.n_reads for seq in sequence_reads]
    total_TCR = sum(reads_list)
    alpha_chain_TCR = sum(
            seq.n_reads for seq in sequence_reads if seq.chain_type == "alpha")
    beta_chain_TCR = sum(
            seq.n_reads for seq in sequence_reads if seq.chain_type == "beta")
    
    if total_TCR: 
        TCR_Richness = len(sequence_reads)
        TCR_Shannon = calculate_shannon(reads_list, total_TCR)
        TCR_Evenness = TCR_Shannon  / math.log(TCR_Richness)
    else:
        TCR_Shannon, TCR_Richness, TCR_Evenness = None
        
    result = Result(
            sample_name,
            total_TCR,
            alpha_chain_TCR,
            beta_chain_TCR,
            TCR_Shannon,
            TCR_Richness,
            TCR_Evenness)
        
    return result
    
def calculate_shannon(reads_list, total_reads):
    ratios = (reads/total_reads for reads in reads_list)
    return(-1 * sum(r * math.log(r) for r in ratios))


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument("--alpha_chain_file", type = str)
    parser.add_argument("--beta_chain_file", type = str)
    parser.add_argument(
        "--output_file", 
        default = "use_sample_name", 
        type = str
    )
    parser.add_argument(
        "--sample_name",
        default = "sample", 
        type = str
    )
    args = parser.parse_args()
    
    main(
        args.alpha_chain_file, 
        args.beta_chain_file, 
        args.output_file,
        args.sample_name
    )
    



    


