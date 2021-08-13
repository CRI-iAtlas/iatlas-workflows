#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:

  - id: synapse_config
    type: File
  
  - id: cohorts
    type:
      type: array
      items: string
 
  - id: iatlas_dataset
    type: string
    
  - id: parent_tags
    type:
      type: array
      items:
        type: array
        items: string
        
  - id: fantom_output_nodes_files
    type:
      type: array
      items: string
      
  - id: fantom_output_edges_files
    type:
      type: array
      items: string
      
  - id: cellimage_output_nodes_files
    type:
      type: array
      items: string
      
  - id: cellimage_output_edges_files
    type:
      type: array
      items: string
      
  - id: nodes_output_parent_synapse_id
    type: string
    
  - id: edges_output_parent_synapse_id
    type: string
   
outputs: 

  - id: fantom_nodes_file_ids
    type: string[]
    outputSource: fantom_network_analysis/nodes_file_id
    
  - id: fantom_edges_file_ids
    type: string[]
    outputSource: fantom_network_analysis/edges_file_id
    
  - id: cellimage_nodes_file_ids
    type: string[]
    outputSource: cellimage_network_analysis/nodes_file_id
    
  - id: cellimage_edges_file_ids
    type: string[]
    outputSource: cellimage_network_analysis/edges_file_id

steps:

  - id: fantom_network_analysis
    run: fantom_api_workflow.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: cohorts
        source: cohorts
      - id: iatlas_dataset
        source: iatlas_dataset
      - id: parent_tags
        source: parent_tags
      - id: nodes_output_parent_synapse_id
        source: nodes_output_parent_synapse_id
      - id: edges_output_parent_synapse_id
        source: edges_output_parent_synapse_id
      - id: output_nodes_file
        source: fantom_output_nodes_files
      - id: output_edges_file
        source: fantom_output_edges_files
    out:
      - id: nodes_file_id
      - id: edges_file_id
    scatter:
      - parent_tags
      - output_nodes_file
      - output_edges_file
    scatterMethod: dotproduct

  - id: cellimage_network_analysis
    run: cellimage_api_workflow.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: cohorts
        source: cohorts
      - id: iatlas_dataset
        source: iatlas_dataset
      - id: parent_tags
        source: parent_tags
      - id: nodes_output_parent_synapse_id
        source: nodes_output_parent_synapse_id
      - id: edges_output_parent_synapse_id
        source: edges_output_parent_synapse_id
      - id: output_nodes_file
        source: cellimage_output_nodes_files
      - id: output_edges_file
        source: cellimage_output_edges_files
    out:
      - id: nodes_file_id
      - id: edges_file_id
    scatter:
      - parent_tags
      - output_nodes_file
      - output_edges_file
    scatterMethod: dotproduct

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
