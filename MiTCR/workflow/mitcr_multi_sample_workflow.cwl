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

- id: p1_fastq_array
  type: File[]

- id: p2_fastq_array
  type: File[]

- id: sample_name_array
  type: string[]

- id: output_file_name
  type: string
  default: "mitcr_summary.tsv"
      
      
outputs:

- id: mitcr_summary_file 
  type: File
  outputSource: 
  - combine_mitcr_files/combined_file

steps:

- id: scatter_mitcr
  run: mitcr_workflow.cwl
  in: 
  - id: p1_fastq
    source: p1_fastq_array
  - id: p2_fastq
    source: p2_fastq_array
  - id: sample_name
    source: sample_name_array
  scatter: 
  - p1_fastq
  - p2_fastq
  - sample_name
  scatterMethod: dotproduct
  out: 
  - mitcr_summary_file

- id: combine_mitcr_files
  run: steps/r_tidy_utils/combine_tabular_files.cwl
  in: 
  - id: files
    source: scatter_mitcr/mitcr_summary_file
  - id: output_file_name
    source: output_file_name
  out: 
  - combined_file
  





    
