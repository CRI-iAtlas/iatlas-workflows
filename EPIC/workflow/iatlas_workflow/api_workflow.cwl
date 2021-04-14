#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:

  - id: datasets
    type: string[]
  - id: output_file
    type: string
  - id: synapse_config
    type: File

  
outputs: []
   

steps:

  - id: api_query
    run: ../steps/utils/query_gene_expression.cwl
    in: 
      - id: datasets
        source: datasets
      - id: gene_types
        valueFrom: $(["epic_gene"])
    out:
      - output_file
      
  - id: format_expression
    run: ../steps/r_tidy_utils/format_file.cwl
    in: 
      - id: input_file
        source: api_query/output_file
      - id: output_file
        valueFrom: $("expression.tsv")
      - id: output_file_type
        valueFrom: $("tsv")
      - id: output_type
        valueFrom: $("wide")
      - id: name_column
        valueFrom: $("sample")
      - id: value_column
        valueFrom: $("rna_seq_expr")
      - id: id_column
        valueFrom: $(["hgnc"])
    out:
      - output_file

  - id: epic
    run: ../steps/epic/epic.cwl
    in:
    - id: input_expression_file
      source: format_expression/output_file
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

  - id: format_cell_counts
    run: ../steps/r_tidy_utils/format_file.cwl
    in: 
      - id: input_file
        source: postprocessing/cell_counts_file
      - id: output_file
        source: output_file
      - id: input_file_type
        valueFrom: $("tsv")
      - id: input_type
        valueFrom: $("wide")
      - id: name_column
        valueFrom: $("feature")
      - id: id_column
        valueFrom: $(["sample"])
    out:
      - output_file

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.3/cwl/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: format_cell_counts/output_file
    - id: parentid
      valueFrom: $("syn22125617")
    out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


