#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: insilicodb/kallisto

baseCommand: 
- kallisto 
- quant
- --output-dir,
- "./"

inputs:

  fastq_array:
    type: File[]
    inputBinding: 
      position: 1

  index:
    type: File
    inputBinding:
      prefix: --index

  threads:
    type: int?
    inputBinding:
      prefix: --threads
      
  plaintext:
    type: boolean?
    inputBinding:
      prefix: --plaintext
      
  is_single_end:
    type: boolean?
    inputBinding:
      prefix: --single
     
outputs:

  abundance_file:
    type: File
    outputBinding:
      glob: "abundance.*"
