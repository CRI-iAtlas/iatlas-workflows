#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/network_analysis.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/network_analysis:1.0

inputs:

- id: expression_file
  type: File
  inputBinding:
    prefix: --expression_file
  doc: tab_seperated_file with columns "sample", "node", "value"
  
- id: cell_abundance_file
  type: File
  inputBinding:
    prefix: --cell_abundance_file
  doc: tab_seperated_file with columns "sample", "node", "value" 
  
- id: group_file
  type: File
  inputBinding:
    prefix: --group_file
  doc: tab_seperated_file with columns "sample", "group"
  
- id: scaffold_file
  type: File
  inputBinding:
    prefix: --scaffold_file
  doc: tab_seperated_file with columns "from", "to"

outputs:

- id: nodes_file
  type: File
  outputBinding:
    glob: "nodes.tsv"
    
- id: edges_file
  type: File
  outputBinding:
    glob: "edges.tsv"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
