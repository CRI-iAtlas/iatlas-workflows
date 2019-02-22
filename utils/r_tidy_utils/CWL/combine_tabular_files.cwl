#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/combine_tabular_files.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils

inputs:

  files: 
    type: File[]
    inputBinding:
      prefix: --files

  input_delimiter: 
    type: string
    default: "\t"
    inputBinding:
      prefix: --input_delimiter

  output_delimiter: 
    type: string
    default: "\t"
    inputBinding:
      prefix: --output_delimiter

  output_file_name: 
    type: string
    default: "output.tsv"
    inputBinding:
      prefix: --output_file_name
      
outputs:

  combined_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
