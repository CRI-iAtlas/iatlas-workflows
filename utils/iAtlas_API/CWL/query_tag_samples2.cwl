#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/query_tag_samples2.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/iatlas_api:1.1

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

- id: features
  type: string[]?
  inputBinding:
    prefix: --features

- id: feature_classes
  type: string[]?
  inputBinding:
    prefix: --feature_classes
    
- id: samples
  type: string[]?
  inputBinding:
    prefix: --samples
    
- id: min_value
  type: double?
  inputBinding:
    prefix: --min_value

- id: max_value
  type: double?
  inputBinding:
    prefix: --max_value
    
outputs:

- id: output_file
  type: File
  outputBinding:
    glob: "tag_samples.feather"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



