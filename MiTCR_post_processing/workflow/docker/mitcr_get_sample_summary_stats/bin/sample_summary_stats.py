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
    TCR_total_reads: int = 0
    TCR_alpha_chain_reads: int = 0
    TCR_beta_chain_reads: int = 0
    TCR_Richness: int = 0
    TCR_Shannon: float = None
    TCR_Evenness: float = None

def main(alpha_chain_file, beta_chain_file, output_file, sample_name):
    sequence_reads = create_sequence_reads(alpha_chain_file, beta_chain_file)
    result = Result(sample_name)
    add_metrics_to_result(result, sequence_reads)
    
    if(output_file == "use_sample_name"):
        output_json = sample_name + ".json"
    else:
        output_json = output_file

    with open(output_json, 'w') as json_file:
        json.dump(vars(result), json_file)
    
# create cdr3 dict ------------------------------------------------------------
def create_sequence_reads(alpha_chain_file, beta_chain_file):
    cdr3_dict = parse_cdr3file_to_dict({}, alpha_chain_file, "alpha")
    cdr3_dict = parse_cdr3file_to_dict(cdr3_dict, beta_chain_file, "beta")
    return(cdr3_dict.values())

    
def parse_cdr3file_to_dict(cdr3_dict, cdr3_file, chain_type):
    with open(cdr3_file, 'r') as f:
        # first line is the mitcr command used to generate the file
        # second line is column headers
        for line in islice(f, 2, None):
            parse_cdr3file_line_to_dict(line, cdr3_dict, chain_type)
    return(cdr3_dict)
    
def parse_cdr3file_line_to_dict(line, cdr3_dict, chain_type):
    # relevant columns are
    # 1: number of reads
    # 3: nucleotide sequence
    # 6: ammino acid sequence
    line_tuple = tuple(line.rstrip().split("\t"))
    n_reads, _, sequence, _, _, aa_sequence, *rest = line_tuple
    n_reads = int(n_reads)
    if sequence_usable(aa_sequence):
        update_cdr3dict_entry(cdr3_dict, sequence, chain_type, n_reads)
    
def sequence_usable(aa_sequence):
    return(all(char not in aa_sequence for char in ["*", "~"]))
    
def update_cdr3dict_entry(cdr3_dict, sequence, chain_type, n_reads):
    entry = cdr3_dict.get(sequence, None)
    if entry is None :
        cdr3_dict[sequence] = SequenceReads(chain_type, n_reads)
    elif n_reads > entry.n_reads:
        cdr3_dict[sequence] = SequenceReads(chain_type, n_reads)
    elif n_reads == entry.n_reads:
        cdr3_dict[sequence] = SequenceReads("ambigious", n_reads)

# calcultate TCR statistics ---------------------------------------------------
def add_metrics_to_result(result, sequence_reads):
    if sequence_reads:
        add_counts_to_result(result, sequence_reads)
        add_stats_to_result(result, (seq.n_reads for seq in sequence_reads))

def add_counts_to_result(result, sequence_reads):
    (result.TCR_total_reads,
    result.TCR_alpha_chain_reads,
    result.TCR_beta_chain_reads,
    result.TCR_Richness) = count_reads(sequence_reads)

def count_reads(sequence_reads):
    richness = alpha_reads = beta_reads = other_reads = 0
    for sequence_read in sequence_reads:
        richness += 1
        if sequence_read.chain_type == "alpha":
            alpha_reads += sequence_read.n_reads
        elif sequence_read.chain_type == "beta":
            beta_reads += sequence_read.n_reads
        else:
            other_reads += sequence_read.n_reads
    total_reads = sum([alpha_reads, beta_reads, other_reads])
    return(total_reads, alpha_reads, beta_reads, richness)
    
def add_stats_to_result(result, reads_iter):
    if result.TCR_total_reads: 
        result.TCR_Shannon = calculate_shannon(
            reads_iter, 
            result.TCR_total_reads
        )
        result.TCR_Evenness = calculate_eveness(
            result.TCR_Shannon, 
            result.TCR_Richness
        )

def calculate_shannon(reads_iter, total_reads):
    ratios = (reads/total_reads for reads in reads_iter)
    return(-1 * sum(ratio * math.log(ratio) for ratio in ratios))
    
def calculate_eveness(shannon, richness):
    return(shannon / math.log(richness))


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
    



    


