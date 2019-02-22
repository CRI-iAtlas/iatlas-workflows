#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: [java]

arguments:
- $(inputs.java_memory)
- -jar
- $(inputs.jar_file_path)
- -pset
- $(inputs.pset_string)

doc: "run mitcr"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mitcr

requirements:
  - class: InlineJavascriptRequirement



inputs:

  input_fastq:
    type: File
    inputBinding:
      position: 4
    doc: MiTCR accepts sequencing data in the fastq format. It can also 
      directly read the data from a gzip ­compressed input file (file name must
      end with ".gz"). Sequence quality information in the fastq file can be
      coded with byte offset equal to 33 (Sanger) or 64 (Solexa), in the later
      case additional ­solexa option should be added to the parameters list.

  output_file_string:
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

  java_memory:
    type: string
    default: "-Xmx10g"
    doc: java runtime maximum heap size

  jar_file_path:
    type: string
    default: "/home/ubuntu/mitcr-1.0.3.jar"
    doc: path to jar file in docker image

  pset_string:
    type: string
    default: "flex"

  species:
    type: string?
    inputBinding:
      prefix: -species
    doc: overrides target species

  gene:
    type: string?
    inputBinding:
      prefix: -gene
    doc: overrides target gene

  cysphe:
    type: int?
    inputBinding:
      prefix: -cysphe
    doc: overrides CDR3 definition. Determines whether to include bounding
      cysteine and phenylalanine into CDR3

  ec:
    type: int?
    inputBinding:
      prefix: -ec
    doc: overrides the error correction level

  quality:
    type: int?
    inputBinding:
      prefix: -quality
    doc: overrides the quality threshold value for segment alignment and low
      quality sequences correction algorithms

  lq:
    type: string?
    inputBinding:
      prefix: -lq
    doc: overrides low quality CDR3s processing strategy

  pcrec:
    type: string?
    inputBinding:
      prefix: -pcrec
    doc: overrides the PCR and high quality sequencing errors correction 
      algorithm

  limit:
    type: string?
    inputBinding:
      prefix: -limit
    doc: limits the number of input sequencing reads, use this parameter to
      normalize several datasets or to have a glance at the data

  level:
    type: int?
    inputBinding:
      prefix: -level
    doc: verbosity level for tab delimited output (see “output formats” 
      section for details). Has no effect if cls is used as output format
  
  solexa:
    type: boolean?
    inputBinding:
      prefix: -solexa
    doc: NOT WORKING, sets the input format of quality strings in fastq files
      to old illumina format (<= Casava 1.3) with 64 offset

outputs:

  mitcr_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file_string)
    doc: see output_string

