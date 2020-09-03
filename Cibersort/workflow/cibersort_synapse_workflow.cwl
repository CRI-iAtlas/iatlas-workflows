#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement

inputs:

- id: synapse_config
  type: File
- id: destination_id
  type: string
- id: input_id
  type: string
- id: output_file
  type: string
  default: "cibersort.feather"
- id: input_file_type
  type: string
  default: "feather"
- id: output_file_type
  type: string
  default: "feather"
- id: parse_method
  type: string
  default: "long_expression"
- id: expression_column
  type: string
  default: "expression"
- id: sample_column
  type: string
  default: "sample"
  
outputs:

- id: output_file_id
  type: string
  outputSource: syn_store/file_id
   

steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: input_id
  out:
  - filepath

- id: cibersort
  run: cibersort_workflow.cwl
  in: 
  - id: input_file
    source: syn_get/filepath
  - id: output_file
    source: output_file
  - id: input_file_type
    source: input_file_type
  - id: output_file_type
    source: output_file_type
  - id: parse_method
    source: parse_method
  - id: expression_column
    source: expression_column
  - id: sample_column
    source: sample_column
  out:
  - aggregated_cibersort_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: cibersort/aggregated_cibersort_file
  - id: parentid
    source: destination_id
  out: 
  - file_id

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


