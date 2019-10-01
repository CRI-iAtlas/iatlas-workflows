#!/usr/bin/env cwl-runner


cwlVersion: v1.0
class: Workflow

doc: sam to fastq workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:

- id: sam_file_id
  type: string
- id: fastq_r1_name
  type: string
- id: fastq_r2_name
  type: string
- id: synapse_config
  type: File
- id: synapse_directory_id
  type: string

outputs: []

steps:

- id: syn_get
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-get-tool.cwl
  in: 
  - id: synapse_config
    source: synapse_config
  - id: synapseid
    source: sam_file_id
  out:
  - filepath

- id: sam_to_fastq_workflow
  run: sam_to_fastq_workflow.cwl
  in: 
  - id: sam_file
    source: syn_get/filepath
  - id: fastq_r1_name
    source: fastq_r1_name
  - id: fastq_r2_name
    source: fastq_r2_name
  out:
  - r1_fastq
  - r2_fastq

- id: upload_to_synapse1
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-store-tool.cwl
  in:
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: sam_to_fastq_workflow/r1_fastq
  - id: parentid
    source: synapse_directory_id
  out: []

- id: upload_to_synapse2
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-store-tool.cwl
  in:
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: sam_to_fastq_workflow/r2_fastq
  - id: parentid
    source: synapse_directory_id
  out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


