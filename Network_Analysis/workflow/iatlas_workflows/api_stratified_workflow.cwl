#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:

  - id: cohorts
    type: string[]
  - id: iatlas_dataset
    type: string
  - id: gene_types
    type: string[]
  - id: iatlas_network
    type: string
  - id: parent_tags
    type: string[]
  - id: features
    type: string[]
  
  - id: scaffold_file_id
    type: string
  - id: input_node_label_id
    type: string

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
  - id: log_expression
    type: boolean
    default: false
  - id: add_noise
    type: boolean
    default: true
  - id: min_group_size
    type: int
    default: 3

outputs: 

  - id: nodes_file_id
    type: string
    outputSource: syn_store_edges/file_id
    
  - id: edges_file_id
    type: string
    outputSource: syn_store_nodes/file_id

steps:

  - id: api_query_gene_expression
    run: ../steps/utils/query_gene_expression.cwl
    in: 
      - id: cohorts
        source: cohorts
      - id: gene_types
        source: gene_types
    out:
      - output_file
      
  - id: api_query_feature_values
    run: ../steps/utils/query_feature_values.cwl
    in: 
      - id: cohorts
        source: cohorts
      - id: features
        source: features
    out:
      - output_file
      
  - id: api_query_groups
    run: ../steps/utils/query_tag_samples_parents.cwl
    in: 
      cohorts: cohorts
      parent_tags: parent_tags
    out:
      - output_file
      
  - id: format_groups
    run: ../steps/utils/pivot_wider.cwl
    in: 
      - id: input_file
        source: api_query_groups/output_file
      - id: id_column
        valueFrom: $(["sample_name"])
      - id: name_column
        valueFrom: $("parent_tag_name")
      - id: value_column
        valueFrom: $("tag_name")
      
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
    
  - id: network_analysis
    run: ../steps/network_analysis/network_analysis.cwl
    in: 
    
      - id: input_expression_file
        source: api_query_gene_expression/output_file
      - id: input_celltype_file
        source: api_query_feature_values/output_file
      - id: input_group_file
        source: format_groups/output_file
      - id: input_scaffold_file
        source: syn_get_scaffold/filepath
      - id: input_node_label_file
        source: syn_get_node_labels/filepath
        
      - id: group_sample_col
        valueFrom: $("sample_name")
      - id: group_name_cols
        source: parent_tags
      - id: celltype_value_col
        valueFrom: $("feature_value")
      - id: celltype_node_col
        valueFrom: $("feature_name")
      - id: celltype_sample_col
        valueFrom: $("sample")
      - id: expression_value_col
        valueFrom: $("rna_seq_expr")
      - id: expression_node_col
        valueFrom: $("entrez")
      - id: expression_sample_col
        valueFrom: $("sample")
      - id: scaffold_from_col
        valueFrom: $("from")
      - id: scaffold_to_col
        valueFrom: $("to")
        
      - id: iatlas_output
        valueFrom: $(true)
      - id: iatlas_dataset
        source: iatlas_dataset
      - id: iatlas_network
        source: iatlas_network
        
      - id: add_noise
        source: add_noise
      - id: log_expression
        source: log_expression
      - id: output_nodes_file
        source: output_nodes_file
      - id: output_edges_file
        source: output_edges_file
      - id: input_file_type
        source: input_file_type
      - id: output_file_type
        source: output_file_type
      - id: min_group_size
        source: min_group_size
    
    out:
      - id: nodes_file
      - id: edges_file

  - id: syn_store_nodes
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: file_to_store
        source: network_analysis/nodes_file
      - id: parentid
        source: nodes_output_parent_synapse_id
      - id: name
        source: output_nodes_file
    out: 
      - file_id

  - id: syn_store_edges
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: file_to_store
        source: network_analysis/edges_file
      - id: parentid
        source: edges_output_parent_synapse_id
      - id: name
        source: output_edges_file
    out: 
      - file_id
        
$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb