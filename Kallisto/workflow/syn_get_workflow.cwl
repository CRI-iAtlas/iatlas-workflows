#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement

inputs:
  
- id: id_array
  type: string[]

- id: synapse_config
  type: File

outputs:

- id: file_array
  type: File[]
  outputSource: syn_get/filepath
  
steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: id_array
  scatter: synapseid
  out:
  - filepath
