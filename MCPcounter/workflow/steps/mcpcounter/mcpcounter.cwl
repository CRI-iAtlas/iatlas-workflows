#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/mcpcounter.R

doc: "run MCPcounter"

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mcpcounter:1.0

inputs:

- id: input_expression_file
  type: File
  inputBinding:
    position: 1
    prefix: --input_expression_file
  doc: Path to input matrix of microarray expression data. Tab separated file with features in rows and samples in columns
    
- id: output_file_string
  type: string
  inputBinding:
    prefix: --output_file
  default: "./output_file.tsv"
  doc: path to write output file

- id: features_type
  type: string
  inputBinding:
    prefix: --features_type
  default: "affy133P2_probesets"
  doc: Type of identifiers for expression features. Defaults to 'affy133P2_probesets' for Affymetrix Human Genome 133 Plus 2.0 probesets. Other options are 'HUGO_symbols' (Official gene symbols) or 'ENTREZ_ID' (Entrez Gene ID)

- id: input_probeset_file
  type: File?
  inputBinding:
    prefix: --input_probeset_file
  doc: Path to input table of gene data. Tab separated file of probesets transcriptomic markers and corresponding cell populations. Fetched from github by a call to read.table by default, but can also be a data.frame

- id: input_gene_file
  type: File?
  inputBinding:
    prefix: --input_gene_file
  doc: Path to input table of gene data. Tab separated file of genes transcriptomic markers (HUGO symbols or ENTREZ_ID) and corresponding cell populations. Fetched from github by a call to read.table by default, but can also be a data.frame

outputs:

- id: mcpcounter_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_string)
  doc: see output_string

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



