#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: MultipleInputFeatureRequirement
- class: ScatterFeatureRequirement

inputs:
  
- id: expression_file_id
  type: string

- id: destination_id
  type: string

- id: synapse_config
  type: File

- id: cibersort_output_name
  type: string
  default: "cibersort.tsv"

- id: mcpcounter_output_name
  type: string
  default: "mcpcounter.tsv"

- id: epic_output_name
  type: string
  default: "epic.tsv"

- id: leukocyte_fractions
  type: double[]?

outputs: []

steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: expression_file_id
  out:
  - filepath

- id: deconvolution
  run: deconvolution_workflow.cwl
  in: 
  - id: expression_file
    source: syn_get/filepath
  - id: cibersort_output_name
    source: cibersort_output_name
  - id: mcpcounter_output_name
    source: mcpcounter_output_name
  - id: epic_output_name
    source: epic_output_name
  - id: leukocyte_fractions
    source: leukocyte_fractions
  out:
  - cibersort_file
  - epic_file
  - mcpcounter_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: [deconvolution/cibersort_file, deconvolution/epic_file, deconvolution/mcpcounter_file]
  - id: parentid
    source: destination_id
  scatter: file_to_store
  out: []




