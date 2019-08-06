#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/combine_tabular_files.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.0

inputs:

- id: files 
  type: File[]
  inputBinding:
    prefix: --files

- id: input_delimiter 
  type: string
  default: "\t"
  inputBinding:
    prefix: --input_delimiter

- id: output_delimiter
  type: string
  default: "\t"
  inputBinding:
    prefix: --output_delimiter

- id: output_file_name
  type: string
  default: "output.tsv"
  inputBinding:
    prefix: --output_file_name
      
outputs:

- id: combined_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_name)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
