
library(MCPcounter)

expression <- MCPcounterExampleData

probesets = read.table(
    curl("http://raw.githubusercontent.com/ebecht/MCPcounter/master/Signatures/probesets.txt"),
    sep = "\t",
    stringsAsFactors = FALSE,
    colClasses="character")

genes = read.table(
    curl("http://raw.githubusercontent.com/ebecht/MCPcounter/master/Signatures/genes.txt"),
    sep="\t",
    stringsAsFactors=FALSE,
    header=TRUE,
    colClasses="character",
    check.names=FALSE)

write.table(expression, "sample.expression.matrix.tsv", sep = "\t")
write.table(genes, "sample.genes.table.tsv", sep = "\t")
write.table(probesets, "sample.probes.table.tsv", sep = "\t")