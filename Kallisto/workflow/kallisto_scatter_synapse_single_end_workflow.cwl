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

- id: sample_names
  type: string[]

- id: destination_id
  type: string

- id: fragment_length
  type: float
  default: 200

- id: fragment_length_sd
  type: float
  default: 30
  
outputs: []

steps:

- id: kallisto
  run: kallisto_synapse_single_end_workflow.cwl
  in: 
  - id: fastq_id
    source: fastq_ids
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
  - id: fragment_length
    source: fragment_length
  - id: fragment_length_sd
    source: fragment_length_sd
  scatter:
  - fastq_id
  - sample_name
  scatterMethod: dotproduct
  out: []

