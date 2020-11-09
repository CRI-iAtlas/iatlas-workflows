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

- id: input_expression_file
  type: File
  inputBinding:
    prefix: --input_expression_file
  
- id: input_celltype_file
  type: File
  inputBinding:
    prefix: --input_celltype_file
  
- id: input_group_file
  type: File
  inputBinding:
    prefix: --input_group_file
  
- id: input_scaffold_file
  type: File
  inputBinding:
    prefix: --input_scaffold_file
    
- id: input_node_label_file
  type: File?
  inputBinding:
    prefix: --input_node_label_file
    
- id: output_nodes_file
  type: string
  default: "output_nodes.feather"
  inputBinding:
    prefix: --output_nodes_file
    
- id: output_edges_file
  type: string
  default: "output_edges.feather"
  inputBinding:
    prefix: --output_edges_file
    
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
    
- id: group_sample_col
  type: string
  default: "sample"
  inputBinding:
    prefix: --group_sample_col
    
- id: group_name_cols
  type: string[]
  default: ["group"]
  inputBinding:
    prefix: --group_name_cols

- id: group_name_seperator
  type: string
  default: ":"
  inputBinding:
    prefix: --group_name_seperator

- id: expression_sample_col
  type: string
  default: "sample"
  inputBinding:
    prefix: --expression_sample_col
    
- id: expression_value_col
  type: string
  default: "value"
  inputBinding:
    prefix: --expression_value_col
    
- id: expression_node_col
  type: string
  default: "node"
  inputBinding:
    prefix: --expression_node_col

- id: celltype_sample_col
  type: string
  default: "sample"
  inputBinding:
    prefix: --celltype_sample_col
    
- id: celltype_value_col
  type: string
  default: "value"
  inputBinding:
    prefix: --celltype_value_col
    
- id: celltype_node_col
  type: string
  default: "node"
  inputBinding:
    prefix: --celltype_node_col
    
- id: scaffold_from_col
  type: string
  default: "from"
  inputBinding:
    prefix: --scaffold_from_col
    
- id: scaffold_to_col
  type: string
  default: "to"
  inputBinding:
    prefix: --scaffold_to_col
    
- id: min_group_size
  type: int
  default: 3
  inputBinding:
    prefix: --min_group_size

- id: add_noise
  type: boolean
  default: false 
  inputBinding:
    prefix: --add_noise
    
- id: log_expression
  type: boolean
  default: false 
  inputBinding:
    prefix: --log_expression

- id: iatlas_output
  type: boolean
  default: false 
  inputBinding:
    prefix: --iatlas_output
    
- id: iatlas_dataset
  type: string
  inputBinding:
    prefix: --iatlas_dataset

- id: iatlas_network
  type: string
  inputBinding:
    prefix: --iatlas_network

outputs:

- id: nodes_file
  type: File
  outputBinding:
    glob: $(inputs.output_nodes_file)
    
- id: edges_file
  type: File
  outputBinding:
    glob: $(inputs.output_edges_file)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
