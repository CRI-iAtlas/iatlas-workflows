#!/usr/bin/env cwl-runner
# https://github.com/Sage-Bionetworks/SMC-RNA-Examples/blob/master/rsem/cwl/rsem.cwl
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [rsem-calculate-expression]

doc: "RSEM: Isoform detection"

hints:
  DockerRequirement:
    dockerPull: dreamchallenge/rsem

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 80000

inputs:

  index: Directory

  fastq1:
    type: File
    inputBinding:
      position: 2

  fastq2:
    type: File
    inputBinding:
      position: 2

  pairedend:
    type: boolean?
    inputBinding:
      position: 0
      prefix: --paired-end

  strandspecific:
    type: boolean?
    inputBinding:
      position: 0
      prefix: --strand-specific

  threads:
    type: int?
    inputBinding:
      prefix: -p
      position: 1
  
  output_filename:
    type: string
    inputBinding:
      position: 4

outputs:

  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename + '.isoforms.results')

arguments:
  - valueFrom: $(inputs.index.listing[0].path + "/GRCh37")
    position: 3

