#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement

inputs:
  
  nested_id_array:
    type:
      type: array
      items:
        type: array
        items: string
        
  sample_name_array: string[]
  kallisto_threads: int?
  kallisto_index_file: File
  
outputs: []

steps:

- id: syn_get_and_unzip_fastqs
  run: 
  in: 
  out:

- id: kallisto
  run: 
  in: 
  out:

- id: syn_store_file
  run: 
  in: 
  out:
