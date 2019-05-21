#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/kallisto

baseCommand: 
- kallisto 
- quant
- --output-dir
- "./"

inputs:

- id: fastq1
  type: File
  inputBinding: 
    position: 1

- id: fastq2
  type: File
  inputBinding: 
    position: 1

- id: index
  type: File
  inputBinding:
    prefix: --index

- id: threads
  type: int?
  inputBinding:
    prefix: --threads
      
- id: plaintext
  type: boolean?
  inputBinding:
    prefix: --plaintext

     
outputs:

- id: abundance_h5
  type: File
  outputBinding:
    glob: "abundance.h5"

- id: abundance_tsv
  type: File?
  outputBinding:
    glob: "abundance.tsv"
