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

- id: sam_file_directory
  type: Directory
- id: synapse_config
  type: File
- id: synapse_directory_id
  type: string

outputs: []


steps:

- id: get_files
  run: steps/expression_tools/directory_to_file_array.cwl
  in: 
  - id: directory
    source: sam_file_directory
  out:
  - file_array

- id: filter_bam_files
  run: steps/expression_tools/split_file_array_by_extension.cwl
  in: 
  - id: file_array
    source: get_files/file_array
  - id: file_extension
    valueFrom: ".bam"
  out:
  - array1

- id: create_fastq_names
  run: steps/expression_tools/sam_to_fastq_names.cwl
  in: 
  - id: sam_file_array
    source: filter_bam_files/array1
  out:
  - fastq_names_1
  - fastq_names_2

- id: sam_to_fastq_workflow
  run: sam_to_fastq_workflow.cwl
  in: 
  - id: sam_file_array
    source: filter_bam_files/array1
  - id: fastq_r1_name_array
    source: create_fastq_names/fastq_names_1
  - id: fastq_r2_name_array
    source: create_fastq_names/fastq_names_2
  out:
  - r1_fastq
  - r2_fastq

- id: filter_non_empty_fastq_files
  run: steps/expression_tools/split_file_array_by_size.cwl
  in: 
  - id: file_array
    source: [sam_to_fastq_workflow/r1_fastq, sam_to_fastq_workflow/r2_fastq]
    linkMerge: merge_flattened
  - id: size_filter
    valueFrom: $(1)
  out:
  - array1

- id: upload_to_synapse
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-store-tool.cwl
  in:
  - id: synapse_config
    source: synapse_config
  - id: file_to_store
    source: filter_non_empty_fastq_files/array1
  - id: parentid
    source: synapse_directory_id
  scatter: file_to_store
  out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


