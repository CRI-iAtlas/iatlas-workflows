#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/format_expression_file.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.0

requirements:
- class: InlineJavascriptRequirement


inputs:

- id: input_file
  type: File
  inputBinding:
    prefix: -i

- id: sample_name
  type: string
  inputBinding:
    prefix: -s

- id: output_file
  type: string
  default: "output.tsv"
  inputBinding:
    prefix: -o

- id: parse_method
  type: string
  default: kallisto
  inputBinding:
    prefix: -m

- id: kallisto_expr_column
  type: string
  default: tpm
  inputBinding:
    prefix: -e

- id: kallisto_gene_column
  type: string
  default: value6
  inputBinding:
    prefix: -g

      
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
