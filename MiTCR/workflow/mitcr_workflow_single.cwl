#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: StepInputExpressionRequirement
- class: MultipleInputFeatureRequirement

inputs:

- id: p1_fastq
  type: File

- id: sample_name
  type: string
      
      
outputs:

- id: mitcr_summary_file 
  type: File
  outputSource: 
    get_mitcr_summary/mitcr_summary_file

steps:
  
- id: combine_and_clean_fastqs
  run: steps/mitcr_combine_and_clean_fastqs/mitcr_combine_and_clean_fastqs.cwl 
  in: 
  - id: fastq_array
    source: [p1_fastq]
  out: 
  - fastq

- id: mitcr_alpha_chain
  run: steps/mitcr/mitcr.cwl 
  in: 
  - id: input_fastq
    source: combine_and_clean_fastqs/fastq
  - id: output_file_string
    valueFrom: "mitcr_alhpa.txt"
  - id: gene 
    valueFrom: "TRA"
  out: 
  - mitcr_file

- id: mitcr_beta_chain
  run: steps/mitcr/mitcr.cwl 
  in: 
  - id: input_fastq
    source: combine_and_clean_fastqs/fastq
  - id: output_file_string
    valueFrom: "mitcr_beta.txt"
  out: 
  - mitcr_file

- id: combine_and_clean_mitcr_files
  run: steps/mitcr_combine_and_clean_files/mitcr_combine_and_clean_files.cwl
  in: 
  - id: alpha_chain_file
    source: mitcr_alpha_chain/mitcr_file
  - id: beta_chain_file
    source: mitcr_beta_chain/mitcr_file
  - id: sample_name
    source: sample_name
  out: 
  - cdr3_file

- id: get_mitcr_summary
  run: steps/mitcr_get_sample_summary_stats/mitcr_get_sample_summary_stats.cwl
  in: 
  - id: cdr3_file
    source: combine_and_clean_mitcr_files/cdr3_file     
  out: 
  - mitcr_summary_file




    
