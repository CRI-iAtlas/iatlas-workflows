#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:

  - id: datasets
    type: string[]
  - id: gene_types
    type: string[]
  - id: output_file
    type: string
  - id: synapse_config
    type: File
  - id: destination_id
    type: string

  
outputs: []
   

steps:

  - id: api_query
    run: ../steps/utils/query_gene_expression.cwl
    in: 
      datasets: datasets
      gene_types: gene_types
    out:
      - output_file

  - id: epic
    run: ../steps/epic/epic.cwl
    in:
    - id: input_expression_file
      source: api_query/output_file
    out: 
    - epic_file
    
  - id: postprocessing
    run: ../steps/epic_postprocessing/epic_postprocessing.cwl
    in:
    - id: input_epic_file
      source: epic/epic_file
    - id: output_file_string
      source: output_file
    out: 
    - cell_counts_file

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.3/cwl/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: postprocessing/cell_counts_file
    - id: parentid
      source: destination_id
    out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


