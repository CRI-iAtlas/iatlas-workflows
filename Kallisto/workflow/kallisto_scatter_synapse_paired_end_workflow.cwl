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

- id: sample_names
  type: string[]

- id: destination_id
  type: string
  
outputs: []

steps:

- id: kallisto
  run: kallisto_synapse_paired_end_workflow.cwl
  in: 
  - id: fastq1_id
    source: fastq1_ids
  - id: fastq2_id
    source: fastq2_ids
  - id: sample_name
    source: sample_names
  - id: synapse_config
    source: synapse_config
  - id: destination_id
    source: destination_id
  - id: kallisto_threads
    source: kallisto_threads
  - id: kallisto_index_file
    source: kallisto_index_file
  scatter:
  - fastq1_id
  - fastq2_id
  - sample_name
  scatterMethod: dotproduct
  out: []

