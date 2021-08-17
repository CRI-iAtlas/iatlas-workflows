#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement


inputs:

  - id: cohorts
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
      - id: cohorts
        source: cohorts
      - id: gene_types
        valueFrom: $(["immune_subtype_classifier_gene"])
    out:
      - output_file
      
  - id: format_file
    run: ../steps/utils/format_file.cwl
    in: 
      - id: input_file
        source: api_query/output_file
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
  
  - id: clustering
    run: ../steps/immune_subtype_clustering/immune_subtype_clustering.cwl
    in: 
    - id: input_file
      source: format_file/output_file
    - id: output_file
      source: output_file
    - id: input_gene_column
      valueFrom: $("hgnc")
    out:
    - immune_subtypes_file

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: clustering/immune_subtypes_file
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


