#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/format_file.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.1

requirements:
- class: InlineJavascriptRequirement


inputs:

- id: input_file
  type: File
  inputBinding:
    prefix: --input_file
    
- id: output_file
  type: string
  default: "output.feather"
  inputBinding:
    prefix: --output_file
    
- id: input_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --input_file_type
    
- id: output_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --output_file_type

- id: input_type
  type: string
  default: "long"
  inputBinding:
    prefix: --input_type
    
- id: output_type
  type: string
  default: "long"
  inputBinding:
    prefix: --output_type

- id: name_column
  type: string
  default: "name"
  inputBinding:
    prefix: --name_column

- id: value_column
  type: string
  default: "value"
  inputBinding:
    prefix: --value_column  

- id: id_columns
  type: string[]?
  inputBinding:
    prefix: --id_columns
      
outputs:

- id: output_file
  type: File
  outputBinding:
    glob: $(inputs.output_file)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
