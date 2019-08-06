#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- python3
- /usr/local/bin/sample_summary_stats.py

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mitcr_get_sample_summary_stats:1.0

requirements:
  - class: InlineJavascriptRequirement


inputs:

- id: alpha_chain_file 
  type: File
  inputBinding:
    prefix: --alpha_chain_file 

- id: beta_chain_file 
  type: File
  inputBinding:
    prefix: --beta_chain_file 

- id: sample_name
  type: string?
  inputBinding:
    prefix: --sample_name

- id: output_file 
  type: string
  default: "mitcr.json"
  inputBinding:
    prefix: --output_file

outputs:

- id: mitcr_summary_json
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


