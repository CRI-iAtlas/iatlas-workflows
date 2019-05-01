#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/combine_kalisto_files.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils

requirements:
- class: InlineJavascriptRequirement


inputs:

- id: abundance_files 
  type: File[]
  inputBinding:
    prefix: --abundance_files

- id: sample_names
  type: string[]
  inputBinding:
    prefix: --sample_names

- id: abundance_type
  type: string?
  inputBinding:
    prefix: --abundance_type

- id: output_file_name
  type: string
  default: "expression_file.tsv"
  inputBinding:
    prefix: --output_file_name
      
outputs:

- id: expression_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_name)
