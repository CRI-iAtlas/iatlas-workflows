#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: nested_id_array
  type:
    type: array
    items:
      type: array
      items: string

- id: destination_id
  type: string

- id: output_file_name
  type: string
  default: "expression_file.tsv"
        
- id: sample_name_array
  type: string[]

- id: kallisto_threads
  type: int?

- id: kallisto_index_file
  type: File

- id: synapse_config
  type: File

- id: fragment_length
  type: float
  default: 200

- id: fragment_length_sd
  type: float
  default: 30
  
outputs: []

steps:

- id: syn_get_and_unzip_fastqs
  run: syn_get_and_unzip_workflow.cwl
  in: 
  - id: id_array
    source: nested_id_array
  - id: synapse_config
    source: synapse_config
  scatter: id_array
  out:
  - file_array

- id: kallisto
  run: kallisto_workflow.cwl
  in: 
  - id: fastq_nested_array
    source: syn_get_and_unzip_fastqs/file_array
  - id: sample_name_array
    source: sample_name_array
  - id: kallisto_threads
    source: kallisto_threads
  - id: kallisto_index_file
    source: kallisto_index_file
  - id: fragment_length
    source: fragment_length
  - id: fragment_length_sd
    source: fragment_length_sd
  - id: output_file_name
    source: output_file_name
  out: 
  - expression_file

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: kallisto/expression_file
  - id: parentid
    source: destination_id
  out: []
