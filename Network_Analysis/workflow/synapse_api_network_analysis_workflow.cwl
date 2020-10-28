#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement

inputs:

  # API paramters
  datasets: string[]
  gene_types: string[]
  parent_tags: string[]
  features: string[]
  
  # synapse ids
  scaffold_file_id: string
  input_node_label_id: string
  #destination_id: string
  
  # other
  synapse_config: File

outputs: 

  - id: output_synapse_id
    type: File
    outputSource: api_query_gene_expression/output_file

steps:

  - id: api_query_gene_expression
    run: steps/utils/query_gene_expression.cwl
    in: 
      datasets: datasets
      gene_types: gene_types
      parent_tags: parent_tags
    out:
      - output_file
      
  - id: api_query_feature_values
    run: steps/utils/query_feature_values.cwl
    in: 
      datasets: datasets
      features: features
      parent_tags: parent_tags
    out:
      - output_file
      
  - id: api_query_groups
    run: steps/utils/query_samples_by_tags.cwl
    in: 
      datasets: datasets
      features: features
      parent_tags: parent_tags
    out:
      - output_file

  - id: syn_get_scaffold
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: scaffold_file_id
    out:
      - filepath
  
  - id: syn_get_node_labels
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: input_node_label_id
    out:
      - filepath


$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb