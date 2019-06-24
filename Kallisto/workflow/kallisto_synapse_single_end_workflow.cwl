#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement
  
inputs:
  
- id: fastq_id
  type: string

- id: kallisto_index_file
  type: File

- id: synapse_config
  type: File

- id: kallisto_threads
  type: int?

- id: fragment_length
  type: float
  default: 200

- id: fragment_length_sd
  type: float
  default: 30

- id: sample_name
  type: string

- id: output_file_name
  type: string
  default: "expression_file.tsv"

- id: destination_id
  type: string
  
outputs: []

steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: fastq_id
  out:
  - filepath

- id: kallisto
  run: kallisto_single_end_workflow.cwl
  in: 
  - id: fastq
    source: syn_get/filepath
  - id: kallisto_threads
    source: kallisto_threads
  - id: kallisto_index_file
    source: kallisto_index_file
  - id: fragment_length
    source: fragment_length
  - id: fragment_length_sd
    source: fragment_length_sd
  out: 
  - abundance_tsv

- id: rename_file
  run: steps/expression_tools/rename_file.cwl
  in: 
  - id: input_file
    source: kallisto/abundance_tsv
  - id: new_file_name
    source: sample_name
    valueFrom: $(self + ".tsv")
  out: 
  - output_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: rename_file/output_file
  - id: parentid
    source: destination_id
  out: []
