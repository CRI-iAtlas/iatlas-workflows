#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/query_mutations.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/iatlas_api:1.2

inputs:

- id: datasets
  type: string[]?
  inputBinding:
    prefix: --datasets
    
- id: parent_tags
  type: string[]?
  inputBinding:
    prefix: --parent_tags
    
- id: tags
  type: string[]?
  inputBinding:
    prefix: --tags
    
- id: samples
  type: string[]?
  inputBinding:
    prefix: --samples

- id: types
  type: string[]?
  inputBinding:
    prefix: --types
    
- id: status
  type: string[]?
  inputBinding:
    prefix: --status

outputs:

- id: output_file
  type: File
  outputBinding:
    glob: "mutations.feather"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



