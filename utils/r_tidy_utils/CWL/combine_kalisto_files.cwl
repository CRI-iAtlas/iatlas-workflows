#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/combine_kalisto_files.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.0

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

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
