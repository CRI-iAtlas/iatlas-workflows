#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/format_expression_file.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.1.1

requirements:
- class: InlineJavascriptRequirement


inputs:

- id: input_file
  type: File
  inputBinding:
    prefix: --input_file
    
- id: output_file
  type: string
  default: "expression.feather"
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

- id: parse_method
  type: string
  default: "long_expression"
  inputBinding:
    prefix: --parse_method
    
- id: drop_na
  type: boolean
  default: false 
  inputBinding:
    prefix: --drop_na

- id: expression_column
  type: string
  default: "expression"
  inputBinding:
    prefix: --expression_column

- id: sample_column
  type: string
  default: "sample"
  inputBinding:
    prefix: --sample_column  

- id: sample_name
  type: string?
  inputBinding:
    prefix: --sample_name

- id: kallisto_expr_column
  type: string
  default: tpm
  inputBinding:
    prefix: --kallisto_expr_column

- id: kallisto_gene_column
  type: string
  default: value6
  inputBinding:
    prefix: --kallisto_gene_column

      
outputs:

- id: expression_file
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
