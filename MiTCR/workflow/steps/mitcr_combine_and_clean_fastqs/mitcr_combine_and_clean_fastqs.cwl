#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- python2
- /usr/local/bin/combine_and_clean_fastqs.py

doc: "preprocessing before mitcr"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mitcr_combine_and_clean_fastqs

inputs:

- id: fastq_array
  type: File[]
  inputBinding:
    prefix: fastqs
  doc: fastq files in the format of ".fastq" or ".fq"

outputs:

- id: fastq
  type: File
  outputBinding:
    glob: "reads.fq"


