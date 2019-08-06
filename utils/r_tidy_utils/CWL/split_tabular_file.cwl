#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

#requirements:
#- class: InlineJavascriptRequirement

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

- id: file_array
  type: File[]
  outputBinding:
    glob: "*"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
