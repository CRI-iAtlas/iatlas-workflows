#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

doc: >
  Workflow for pulling input files for `calculate_driver_results`
  from Synapse, running the analysis, and storing the output on
  Synapse. For more information on any given input parameter, 
  refer to the corresponding tool's CWL definition. 

inputs:
  synapse_config: File
  features_synapse_id: string
  groups_synapse_id: string
  mutations_synapse_id: string
  results_parent_synapse_id: string
  input_file_type: string?
  output_file: string?
  output_file_type: string?
  feature_sample_column: string?
  feature_name_column: string?
  feature_value_column: string?
  group_sample_column: string?
  group_name_column: string?
  mutation_name_columns: string[]?
  mutation_name_separator: string?
  mutation_sample_column: string?
  mutation_status_column: string?
  num_significant_digits: int?

outputs: []

steps:

  - id: syn_get_features
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: features_synapse_id
    out:
      - filepath
  
  - id: syn_get_groups
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: groups_synapse_id
    out:
      - filepath
  
  - id: syn_get_mutations
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
    in: 
      synapse_config: synapse_config
      synapseid: mutations_synapse_id
    out:
      - filepath

  - id: calculate_driver_results
    run: steps/driver_mutation_results/calculate_driver_results.cwl
    in: 
      input_feature_file: syn_get_features/filepath
      input_group_file: syn_get_groups/filepath
      input_mutation_file: syn_get_mutations/filepath
      input_file_type: input_file_type
      output_file: output_file
      output_file_type: output_file_type
      feature_sample_column: feature_sample_column
      feature_name_column: feature_name_column
      feature_value_column: feature_value_column
      group_sample_column: group_sample_column
      group_name_column: group_name_column
      mutation_name_columns: mutation_name_columns
      mutation_name_separator: mutation_name_separator
      mutation_sample_column: mutation_sample_column
      mutation_status_column: mutation_status_column
      num_significant_digits: num_significant_digits
    out:
      - driver_results

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
    in: 
      synapse_config: synapse_config
      file_to_store: calculate_driver_results/driver_results
      parentid: results_parent_synapse_id
    out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
