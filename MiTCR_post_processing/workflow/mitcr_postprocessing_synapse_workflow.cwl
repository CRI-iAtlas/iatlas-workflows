#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: ScatterFeatureRequirement

inputs:

- id: alpha_chain_ids
  type: string[]

- id: beta_chain_ids
  type: string[]

- id: sample_names
  type: string[]

- id: output_files
  type: string[]

- id: synapse_config
  type: File

- id: destination_id
  type: string
      
outputs: []

steps: 

- id: get_alpha_chain_files
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: alpha_chain_ids
  scatter: synapseid
  out:
  - filepath

- id: get_beta_chain_files
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: beta_chain_ids
  scatter: synapseid
  out:
  - filepath

- id: post_processing
  run: steps/mitcr_get_sample_summary_stats/mitcr_get_sample_summary_stats.cwl
  in: 
  - id: alpha_chain_file 
    source: get_alpha_chain_files/filepath
  - id: beta_chain_file 
    source: get_beta_chain_files/filepath
  - id: sample_name
    source: sample_names
  - id: output_file 
    source: output_files
  scatter: 
  - alpha_chain_file 
  - beta_chain_file 
  - sample_name
  - output_file
  scatterMethod: dotproduct
  out:
  - mitcr_summary_json

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: post_processing/mitcr_summary_json
  - id: parentid
    source: destination_id
  scatter: file_to_store
  out: []





  





    
