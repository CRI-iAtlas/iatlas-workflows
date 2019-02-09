'''
Sample Summary Stats
Compute summary statistics for each subject (TCGA PanCanAtlas)

Date: April 12, 2016
@author: sbrown
Modifications July 12, 2016 vthorsson
'''

## Import Libraries 
import sys
import argparse
import math

DEBUG = False
VERB = False

''' Functions '''

def getAllBarcodes(cdr3File): ## gets all barcodes. Only for cases where no productive sequences remain after filtering.
	barcodes = []
	HEADER = True
	for line in open(cdr3File, "r"):
		if HEADER:
			HEADER = False
		else:
			line = line.rstrip().split("\t")
			bar = line[0]
			if bar not in barcodes:
				barcodes.append(bar)
	return barcodes

def readAndCleanCDR3(cdr3File):
    cdr3 = {}
    ## format will be cdr3[barcode] = {seq: [[abund,chain],[abund,chain]]}
    
    totalSeq = 0
    totalProdSeq = 0
    totalProdUniqueSeq = 0
        
    HEADER = True
    for line in open(cdr3File, "r"):
        if HEADER:
            HEADER = False
        else:
            totalSeq += 1
            
            if VERB and totalSeq % 10000 == 0: print("Parsed {} entries...".format(totalSeq))
            
            line = line.rstrip().split("\t")
            bar = line[0]
            chain = line[1]
            abund = int(line[2])
            seq = line[3]   ## nucSeq
            aaSeq = line[4]
            
            if "*" not in aaSeq and "~" not in aaSeq: ## Tossing frameshifts and stop codons to yield Productive seqs.  Only use of aaSeq.
                totalProdSeq += 1
                
                ## add to dictionary
                if bar not in cdr3:
                    cdr3[bar] = {}
                if seq not in cdr3[bar]:
                    cdr3[bar][seq] = []
                cdr3[bar][seq].append([abund,chain])
    
    if VERB: print("Finished reading in CDR3 file.")
    if VERB: print("Total sequences: {}".format(totalSeq))
    if VERB: print("Total productive sequences: {}".format(totalProdSeq))
    
    if VERB: print("Resolving ambiguous chain assignment...")
    
    for bar in cdr3:
        for seq in cdr3[bar]:
            if len(cdr3[bar][seq]) > 1:
                ## more than one entry for that sequence.
                curmax = 0
                best = []
                if VERB: print("Resolving ambiguity for {}".format(bar))
                for item in cdr3[bar][seq]:
                    if item[0] > curmax:
                        ## new potential resolution
                        best = item
                        curmax = item[0]
                    elif item[0] == curmax and best[1] != item[1]:  ## same abudance, different chains
                        best = [item[0],"ambiguous"]
                    ## if same abundance and same chain, leave alone.
                    ## if lesser abundance, leave alone.
                ## set to the best.
                cdr3[bar][seq] = best
            else:
                cdr3[bar][seq] = cdr3[bar][seq][0]  ## change from list of tuples to tuple.
    
    return cdr3

def readAndCleanSample(cdr3):
	samples = {}
	bars = cdr3.keys()
	for bar in bars:
		samples[bar] = {}
	if VERB: print("Getting sample-specific stats.")
	for bar in samples:
		## get total number of alpha reads
		## get total number of beta reads
		numAlpha = 0
		numBeta = 0
		numTot = 0
		for seq in cdr3[bar]:
			numTot += cdr3[bar][seq][0]
			if cdr3[bar][seq][1] == "alpha":
				numAlpha += cdr3[bar][seq][0]
			elif cdr3[bar][seq][1] == "beta":
				numBeta += cdr3[bar][seq][0]
		samples[bar]["totTCR"] = numTot
		samples[bar]["totTCRa"] = numAlpha
		samples[bar]["totTCRb"] = numBeta
	return samples

def calcEntropy(samples, cdr3):
    
    ## shannon entropy
    ## negative summation of pi*ln(pi) where pi is proportion of reads beloning to ith seq.
    
    if VERB: print("Calculating Shannon Entropies.")
    
    for bar in samples:
        
        shannon = None
        numClones = None
        if samples[bar]["totTCR"] != 0: ## there was yield.
            numClones = len(cdr3[bar])
            shannon = 0
            for seq in cdr3[bar]:
                p = float(cdr3[bar][seq][0]) / float(samples[bar]["totTCR"])
                shannon += p*math.log(p)
            shannon = -1 * shannon
        samples[bar]["shannon"] = shannon
        samples[bar]["numClones"] = numClones
        
        if DEBUG and bar in ["TCGA-04-1350-01A-01R-1565-13","TCGA-09-1661-01B-01R-1566-13"]:
            print("DEBUG:\tbar is {}".format(bar))
            print("DEBUG:\tdata is {}".format(cdr3[bar]))
            print("DEBUG:\tshannon is {}".format(shannon))
            print("=================================")
    
    return samples
        

if __name__ == "__main__":
    
    ## Deal with command line arguments
    parser = argparse.ArgumentParser(description = "Compute summary statistics for each subject (TCGA PanCanAtlas)")
    ## add_argument("name", "(names)", metavar="exampleOfValue - best for optional", type=int, nargs="+", choices=[allowed,values], dest="nameOfVariableInArgsToSaveAs")
    parser.add_argument("cdr3File", help = "File containing cdr3 sequences", type = str)
    parser.add_argument("outputFile", help = "File to write summary statistics", type = str)
    parser.add_argument("-debug", action = "store_true", dest = "DEBUG", help = "Flag for setting debug/test state.")
    parser.add_argument("-v", "--verbose", action = "store_true", dest = "VERB", help = "Flag for setting verbose output.")
    args = parser.parse_args()
    
    ## Set Global Vars
    
    #print(args)
    ## arguments accessible as args.cmdline_arg or args.cmdflg or args.destName
    ## can test using parser.parse_args("-cmdflg value other_value".split())
    
    cdr3Dict = readAndCleanCDR3(args.cdr3File)
    
    sampleDict = readAndCleanSample(cdr3Dict)
    
    sampleDict = calcEntropy(sampleDict, cdr3Dict)

    allBarcodes = getAllBarcodes(args.cdr3File)

    lostBarcodes = list(set(allBarcodes)-set(cdr3Dict.keys()))
    
    ## print results
    out = open(args.outputFile, "w")
    ##out.write("barcode\ttotTCR_reads\ttotTCRa_reads\ttotTCRb_reads\tshannon\tnumClones\n")
    for bar in sampleDict:
        out.write("{}\t{}\t{}\t{}\t{}\t{}\n".format(bar, sampleDict[bar]["totTCR"], sampleDict[bar]["totTCRa"], sampleDict[bar]["totTCRb"], sampleDict[bar]["shannon"], sampleDict[bar]["numClones"]))
    for bar in lostBarcodes:
        out.write("{}\t0\t0\t0\tNA\t0\n".format(bar))

    out.close()
    
	#    print("done.")
