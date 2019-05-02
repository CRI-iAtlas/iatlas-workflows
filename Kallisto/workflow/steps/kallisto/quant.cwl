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

- id: fastq_array
  type: File[]
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
      
- id: is_single_end
  type: boolean?
  inputBinding:
    prefix: --single

- id: fragment_length
  type: float?
  inputBinding:
    prefix: --fragment-length

- id: sd
  type: float?
  inputBinding:
    prefix: --sd
     
outputs:

  abundance_file:
    type: File
    outputBinding:
      glob: "abundance.*"
