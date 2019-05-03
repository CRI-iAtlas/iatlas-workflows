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
  default: "mitcr_file.tsv"
        
- id: sample_name_array
  type: string[]

- id: synapse_config
  type: File
  
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

- id: mitcr
  run: mitcr_multi_sample_workflow.cwl
  in: 
  - id: fastq_nested_array
    source: syn_get_and_unzip_fastqs/file_array
  - id: sample_name_array
    source: sample_name_array
  - id: output_file_name
    source: output_file_name
  out: 
  - mitcr_summary_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mitcr/mitcr_summary_file
  - id: parentid
    source: destination_id
  out: []
