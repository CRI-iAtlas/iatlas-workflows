#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/split_tabular_file.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils

inputs:

- id: file 
  type: File
  inputBinding:
    prefix: --file

- id: input_delimiter
  type: string
  default: "\t"
  inputBinding:
    prefix: --input_delimiter

- id: output_file_prfix 
  type: string
  default: "output"
  inputBinding:
    prefix: --output_file_prefix

- id: label_column
  type: int
  default: 1
  inputBinding:
    prefix: --label_column
      
outputs:

  combined_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix*)
