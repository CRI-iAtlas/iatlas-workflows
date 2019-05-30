#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: StepInputExpressionRequirement
- class: ScatterFeatureRequirement

inputs:

- id: p1_fastq_id_array
  type: string[]

- id: p2_fastq_id_array
  type: string[]

- id: unpaired_fastq_id_array
  type: string[]

- id: paired_sample_name_array
  type: string[]

- id: unpaired_sample_name_array
  type: string[]

- id: synapse_config
  type: File

- id: destination_id
  type: string
            
outputs: []

steps:

- id: paired_mitcr
  run: mitcr_synapse_workflow_paired.cwl
  in: 
  - id: p1_fastq_id
    source: p1_fastq_id_array
  - id: p2_fastq_id
    source: p2_fastq_id_array
  - id: sample_name
    source: paired_sample_name_array
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

- id: single_mitcr
  run: mitcr_synapse_workflow_single.cwl
  in: 
  - id: fastq_id
    source: unpaired_fastq_id_array
  - id: sample_name
    source: unpaired_sample_name_array
  - id: synapse_config
    source: synapse_config
  - id: destination_id
    source: destination_id
  scatter:
  - fastq_id
  - sample_name
  scatterMethod: dotproduct
  out: []


  





    
