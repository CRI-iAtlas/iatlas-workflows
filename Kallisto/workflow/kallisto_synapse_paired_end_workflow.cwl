#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement
  
inputs:
  
- id: fastq1_ids
  type: string[]

- id: fastq2_ids
  type: string[]

- id: kallisto_index_file
  type: File

- id: synapse_config
  type: File

- id: kallisto_threads
  type: int?

- id: sample_name_array
  type: string[]

- id: output_file_name
  type: string
  default: "expression_file.tsv"

- id: destination_id
  type: string
  
outputs: []

steps:

- id: syn_get1
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: fastq1_ids
  scatter: synapseid
  out:
  - filepath

- id: syn_get2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: fastq2_ids
  scatter: synapseid
  out:
  - filepath

- id: kallisto
  run: kallisto_paired_end_workflow.cwl
  in: 
  - id: fastq1
    source: syn_get1/filepath
  - id: fastq2
    source: syn_get2/filepath
  - id: kallisto_threads
    source: kallisto_threads
  - id: kallisto_index_file
    source: kallisto_index_file
  scatter: 
  - fastq1
  - fastq2
  scatterMethod: dotproduct
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
