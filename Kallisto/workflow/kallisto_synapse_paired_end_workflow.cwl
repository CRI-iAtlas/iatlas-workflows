#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement
  
inputs:
  
- id: fastq1_id
  type: string

- id: fastq2_id
  type: string

- id: kallisto_index_file
  type: File

- id: synapse_config
  type: File

- id: kallisto_threads
  type: int?

- id: sample_name
  type: string

- id: destination_id
  type: string
  
outputs: []

steps:

- id: syn_get1
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: fastq1_id
  out:
  - filepath

- id: syn_get2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: fastq2_id
  out:
  - filepath

- id: kallisto
  run: kallisto_paired_end_workflow.cwl
  in: 
  - id: fastq1
    source: syn_get1/filepath
  - id: fastq2
    source: syn_get2/filepath
  - id: kallisto_threads
    source: kallisto_threads
  - id: kallisto_index_file
    source: kallisto_index_file
  out: 
  - abundance_tsv

- id: rename_file
  run: steps/expression_tools/rename_file.cwl
  in: 
  - id: input_file
    source: kallisto/abundance_tsv
  - id: new_file_name
    source: sample_name
    valueFrom: $(self + ".tsv")
  out: 
  - output_file

- id: syn_store
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: rename_file/output_file
  - id: parentid
    source: destination_id
  out: []
