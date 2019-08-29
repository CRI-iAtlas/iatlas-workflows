#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: p1_fastq_id
  type: string

- id: p2_fastq_id
  type: string

- id: destination_id
  type: string
        
- id: sample_name
  type: string

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
    source: p1_fastq_id
  out:
  - filepath

- id: syn_get2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: p2_fastq_id
  out:
  - filepath

- id: mixcr
  run: steps/mixcr/mixcr.cwl
  in: 
  - id: p1_fastq
    source: syn_get1/filepath
  - id: p2_fastq
    source: syn_get2/filepath
  - id: sample_name
    source: sample_name
  out: 
  - mixcr_TRA_file
  - mixcr_TRB_file
  - mixcr_IGH_file
  - mixcr_IGL_file

- id: syn_store1
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mixcr/mixcr_TRA_file
  - id: parentid
    source: destination_id
  out: []

- id: syn_store2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mixcr/mixcr_TRB_file
  - id: parentid
    source: destination_id
  out: []

- id: syn_store3
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mixcr/mixcr_IGH_file
  - id: parentid
    source: destination_id
  out: []

- id: syn_store4
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mixcr/mixcr_IGL_file
  - id: parentid
    source: destination_id
  out: []

