#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement

doc: >
  Workflow for pulling input files for `calculate_mutation_models`
  from Synapse, running the analysis, and storing the output on
  Synapse. For more information on any given input parameter, 
  refer to the corresponding tool's CWL definition. 

inputs:

  # API paramters
  cohorts: string[]
  mutation_types: string[]
  parent_tags: string[]
  
  # Synapse ids
  output_parent_synapse_id: string
  
  # column names
  feature_sample_column: string?
  feature_name_column: string?
  feature_value_column: string?
  group_sample_column: string?
  group_name_column: string?
  mutation_name_columns: string[]?
  mutation_name_separator: string?
  mutation_sample_column: string?
  mutation_status_column: string?
  
  # other
  synapse_config: File
  output_file: string?
  num_significant_digits: int?

outputs: 

  - id: output_synapse_id
    type: string
    outputSource: syn_store/file_id

steps:

  - id: api_query_feature_values
    run: ../steps/utils/query_feature_values.cwl
    in: 
      cohorts: cohorts
    out:
      - output_file
      
  - id: api_query_groups
    run: ../steps/utils/query_tag_samples.cwl
    in: 
      cohorts: cohorts
      parent_tags: parent_tags
    out:
      - output_file
      
  - id: api_query_mutation_status
    run: ../steps/utils/query_mutation_statuses.cwl
    in:
      cohorts: cohorts
      types: mutation_types
    out:
      - output_file
      
  - id: calculate_mutation_models
    run: ../steps/calculate_mutation_models/calculate_mutation_models.cwl
    in: 
      - id: input_feature_file
        source: api_query_feature_values/output_file
      - id: input_group_file
        source: api_query_groups/output_file
      - id: input_mutation_file
        source: api_query_mutation_status/output_file
      - id: feature_name_column
        valueFrom: $("feature_name")
      - id: feature_value_column
        valueFrom: $("feature_value")
      - id: group_sample_column
        valueFrom: $("sample_name")
      - id: group_name_column
        valueFrom: $("tag_name")
      - id: mutation_name_columns
        valueFrom: $(["mutation_name"])
      - id: mutation_sample_column
        valueFrom: $("sample_name")
      - id: mutation_status_column
        valueFrom: $("mutation_status")
    out:
      - mutation_models

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: file_to_store
        source: calculate_mutation_models/mutation_models
      - id: parentid
        source: output_parent_synapse_id
      - id: name
        source: output_file 
      # The following is commented out until the following PR is merged.
      # Only then can these arguments be used. Update the CWL URL accordingly.
      # https://github.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/pull/30
      # - id: used
      #   source: [features_synapse_id, groups_synapse_id, mutations_synapse_id]
      # - id: executed
      #   valueFrom: $(["https://github.com/CRI-iAtlas/iatlas-workflows/blob/v1.1/Calculate_Mutation_Models/workflow/steps/calculate_mutation_models/calculate_mutation_models.cwl"])
    out: 
      - file_id

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
