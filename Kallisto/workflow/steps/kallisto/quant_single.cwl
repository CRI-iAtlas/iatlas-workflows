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
- --single

inputs:

- id: fastq
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

- id: fragment_length
  type: float
  default: 200
  inputBinding:
    prefix: --fragment-length

- id: sd
  type: float
  default: 30
  inputBinding:
    prefix: --sd
     
outputs:

- id: abundance_h5
  type: File
  outputBinding:
    glob: "abundance.h5"

- id: abundance_tsv
  type: File?
  outputBinding:
    glob: "abundance.tsv"
