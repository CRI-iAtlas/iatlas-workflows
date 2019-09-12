#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:

- id: fastq_ids
  type: string[]

- id: sample_names
  type: string[]

- id: synapse_config
  type: File

- id: destination_id
  type: string
            
outputs: []

steps:

- id: mixcr
  run: mixcr_synapse_workflow_single.cwl
  in: 
  - id: fastq_id
    source: fastq_ids
  - id: sample_name
    source: sample_names
  - id: synapse_config
    source: synapse_config
  - id: destination_id
    source: destination_id
  scatter:
  - fastq_id
  - sample_name
  scatterMethod: dotproduct
  out: []
