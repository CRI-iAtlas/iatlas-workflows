#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:

- id: input_ids
  type: string[]
- id: output_files
  type: string[]
- id: sample_names
  type: string[]
- id: synapse_config
  type: File
- id: destination_id
  type: string

  
outputs: []
   

steps:

- id: epic
  run: epic_synapse_workflow.cwl
  in: 
  - id: input_id
    source: input_ids
  - id: output_file
    source: output_files
  - id: sample_name
    source: sample_names
  - id: synapse_config
    source: synapse_config
  - id: destination_id
    source: destination_id
  scatter: 
  - input_id
  - output_file
  - sample_name
  scatterMethod: dotproduct
  out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
