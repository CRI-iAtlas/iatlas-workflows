#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:

- id: p1_fastq_ids
  type: string[]

- id: p2_fastq_ids
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
  run: mixcr_synapse_workflow_paired.cwl
  in: 
  - id: p1_fastq_id
    source: p1_fastq_ids
  - id: p2_fastq_id
    source: p2_fastq_ids
  - id: sample_name
    source: sample_names
  - id: synapse_config
    source: synapse_config
  - id: destination_id
    source: destination_id
  scatter:
  - p1_fastq_id
  - p2_fastq_id
  - sample_name
  scatterMethod: dotproduct
  out: []
