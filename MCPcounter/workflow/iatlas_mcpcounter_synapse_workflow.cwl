#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement

inputs:

- id: input_id
  type: string
- id: output_file
  type: string
- id: synapse_config
  type: File
- id: destination_id
  type: string

  
outputs: []
   

steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: input_id
  out:
  - filepath

- id: mcpcounter
  run: steps/mcpcounter/mcpcounter.cwl
  in:
  - id: input_expression_file
    source: syn_get/filepath
  - id: features_type
    valueFrom: "HUGO_symbols"
  out: 
  - mcpcounter_file
    
- id: mcpcounter_postprocessing
  run: steps/mcpcounter_postprocessing/mcpcounter_postprocessing.cwl
  in:
  - id: input_mcpcounter_file
    source: mcpcounter/mcpcounter_file
  - id: output_file
    source: output_file
  out: 
  - cell_score_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: mcpcounter_postprocessing/cell_score_file
  - id: parentid
    source: destination_id
  out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb

