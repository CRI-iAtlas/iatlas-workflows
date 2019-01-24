#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/combine_kalisto_files.R]

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/tidy_utils

inputs:

  abundance_files: 
    type: File[]
    inputBinding:
      prefix: --abundance_files

  sample_names: 
    type: string[]
    inputBinding:
      prefix: --sample_names
  
  translation_file:
    type: File
    inputBinding:
      prefix: --translation_file

  abundance_type:
    type: string?
    inputBinding:
      prefix: --abundance_type
      
outputs:

  expression_file:
    type: File
    outputBinding:
      glob: "expression_file.tsv"