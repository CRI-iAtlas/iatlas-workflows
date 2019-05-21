#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement
  
inputs:
  
- id: fastq_ids
  type: string[]

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

- id: sample_name_array
  type: string[]

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
    source: fastq_ids
  scatter: synapseid
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
  scatter: fastq
  out: 
  - abundance_tsv

- id: combine_kalisto_files
  run: steps/r_tidy_utils/combine_kalisto_files.cwl
  in:
  - id: abundance_files
    source: kallisto/abundance_tsv
  - id: sample_names
    source: sample_name_array
  - id: output_file_name
    source: output_file_name
  out: 
  - expression_file


- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: combine_kalisto_files/expression_file
  - id: parentid
    source: destination_id
  out: []
