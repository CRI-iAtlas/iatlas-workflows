#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

inputs:

  - id: cohorts
    type: string[]
  - id: iatlas_dataset
    type: string
  - id: parent_tags
    type: string[]

  - id: synapse_config
    type: File
  - id: nodes_output_parent_synapse_id
    type: string
  - id: edges_output_parent_synapse_id
    type: string
    
  - id: output_nodes_file
    type: string
    default: "output_nodes.feather"
  - id: output_edges_file
    type: string
    default: "output_edges.feather"
  - id: input_file_type
    type: string
    default: "feather"
  - id: output_file_type
    type: string
    default: "feather"
    

outputs: 

  - id: nodes_file_id
    type: string
    outputSource: network_analysis/nodes_file_id
    
  - id: edges_file_id
    type: string
    outputSource: network_analysis/edges_file_id

steps:

  - id: network_analysis
    run: api_workflow.cwl
    in: 
      - id: cohorts
        source: cohorts
      - id: iatlas_dataset
        source: iatlas_dataset
      - id: parent_tags
        source: parent_tags
      - id: gene_types
        valueFrom: $(["extracellular_network"])
      - id: iatlas_network
        valueFrom: $("extracellular_network")
      - id: features
        valueFrom: $(["B_cells_Aggregate2", "Dendritic_cells_Aggregate2", "Eosinophils_Aggregate2", "Macrophage_Aggregate2", "Mast_cells_Aggregate2", "Neutrophils_Aggregate2", "NK_cells_Aggregate2", "T_cells_CD4_Aggregate2", "T_cells_CD8_Aggregate2"])
        
      - id: scaffold_file_id
        valueFrom: $("syn23518510")
      - id: input_node_label_id
        valueFrom: $("syn23531716")
        
      - id: synapse_config
        source: synapse_config
      - id: output_nodes_file
        source: output_nodes_file
      - id: output_edges_file
        source: output_edges_file
      - id: input_file_type
        source: input_file_type
      - id: output_file_type
        source: output_file_type
      - id: nodes_output_parent_synapse_id
        source: nodes_output_parent_synapse_id
      - id: edges_output_parent_synapse_id
        source: edges_output_parent_synapse_id

    out:
      - id: nodes_file_id
      - id: edges_file_id

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
