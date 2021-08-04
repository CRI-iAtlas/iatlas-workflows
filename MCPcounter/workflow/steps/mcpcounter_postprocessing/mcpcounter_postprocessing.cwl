#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/mcpcounter_postprocessing.R

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mcpcounter_postprocessing:1.2

inputs:

- id: input_mcpcounter_file
  type: File
  inputBinding:
    prefix: --input_mcpcounter_file
    
- id: output_file_string
  type: string
  default: "output.tsv"
  inputBinding:
    prefix: --output_file
  

outputs:

- id: cell_score_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_string)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



