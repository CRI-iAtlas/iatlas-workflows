#!/usr/bin/env cwl-runner


cwlVersion: v1.0
class: Workflow

doc: sam to fastq workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:

- id: sam_file_id_array
  type: string[]
- id: fastq_r1_name_array
  type: string[]
- id: fastq_r2_name_array
  type: string[]
- id: synapse_config
  type: File
- id: synapse_directory_id
  type: string

outputs: []


steps:

- id: sam_to_fastq_workflow
  run: sam_to_fastq_synapse_workflow.cwl
  in: 
  - id: sam_file_id
    source: sam_file_id_array
  - id: fastq_r1_name
    source: fastq_r1_name_array
  - id: fastq_r2_name
    source: fastq_r2_name_array
  - id: synapse_config
    source: synapse_config
  - id: synapse_directory_id
    source: synapse_directory_id
  scatter: 
  - sam_file_id
  - fastq_r1_name
  - fastq_r2_name
  scatterMethod: dotproduct
  out: []
  



$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


