#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- java

arguments:
- $(inputs.java_memory)
- -jar
- $(inputs.jar_file_path)
- -pset
- $(inputs.pset_string)

doc: "run mitcr"

hints:
- class: ResourceRequirement
  ramMin: 10000
  tmpdirMin: 25000
- class: DockerRequirement
  dockerPull: quay.io/cri-iatlas/mitcr:1.0


requirements:
- class: InlineJavascriptRequirement



inputs:

- id: input_fastq
  type: File
  inputBinding:
    position: 4
  doc: MiTCR accepts sequencing data in the fastq format. It can also 
       directly read the data from a gzip ­compressed input file (file name must
       end with ".gz"). Sequence quality information in the fastq file can be
       coded with byte offset equal to 33 (Sanger) or 64 (Solexa), in the later
       case additional ­solexa option should be added to the parameters list.

- id: output_file_string
  type: string
  default: "output.txt"
  inputBinding:
    position: 5
  doc: Name of output file. 
       .cls This format is a binary file containing clonotype information to be
       viewed with MiTCR Viewer. This output format will be used if output 
       file name ends with .cls, in all other cases a tab delimited format 
       will be used. 
       tab-delimited This format is a plain text file containing clonotype 
       information formatted as a simple table with columns separated by a tab
       symbol. Additionally, if the file name ends with .gz (e.g. 
       cloneset.txt.gz) it will be automatically compressed using gzip. Three
       verbosity level can be selected using level option

- id: java_memory
  type: string
  default: "-Xmx10g"
  doc: java runtime maximum heap size

- id: jar_file_path
  type: string
  default: "/home/ubuntu/mitcr-1.0.3.jar"
  doc: path to jar file in docker image

- id: pset_string
  type: string
  default: "flex"

- id: species
  type: string?
  inputBinding:
    prefix: -species
  doc: overrides target species

- id: gene
  type: string?
  inputBinding:
    prefix: -gene
  doc: overrides target gene

- id: cysphe
  type: int?
  inputBinding:
    prefix: -cysphe
  doc: overrides CDR3 definition. Determines whether to include bounding
    cysteine and phenylalanine into CDR3

- id: ec
  type: int?
  inputBinding:
    prefix: -ec
  doc: overrides the error correction level

- id: quality
  type: int?
  inputBinding:
    prefix: -quality
  doc: overrides the quality threshold value for segment alignment and low
    quality sequences correction algorithms

- id: lq
  type: string?
  inputBinding:
    prefix: -lq
  doc: overrides low quality CDR3s processing strategy

- id: pcrec
  type: string?
  inputBinding:
    prefix: -pcrec
  doc: overrides the PCR and high quality sequencing errors correction 
       algorithm

- id: limit
  type: string?
  inputBinding:
    prefix: -limit
  doc: limits the number of input sequencing reads, use this parameter to
       normalize several datasets or to have a glance at the data

- id: level
  type: int?
  inputBinding:
    prefix: -level
  doc: verbosity level for tab delimited output (see “output formats” 
       section for details). Has no effect if cls is used as output format

outputs:

- id: mitcr_file
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

