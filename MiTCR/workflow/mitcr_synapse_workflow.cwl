#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: p1_fastq_ids
  type: string[]

- id: p2_fastq_ids
  type: string[]

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

- id: syn_get1
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: p1_fastq_ids
  scatter: synapseid
  out:
  - filepath

- id: syn_get2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: p2_fastq_ids
  scatter: synapseid
  out:
  - filepath

- id: mitcr
  run: mitcr_multi_sample_workflow.cwl
  in: 
  - id: p1_fastq_array
    source: syn_get1/filepath
  - id: p2_fastq_array
    source: syn_get2/filepath
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
