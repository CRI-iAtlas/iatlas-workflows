#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: StepInputExpressionRequirement
- class: MultipleInputFeatureRequirement
- class: InlineJavascriptRequirement

inputs:

- id: p1_fastq
  type: File

- id: p2_fastq
  type: File

- id: sample_name
  type: string
  default: "mitcr"
      
      
outputs:

- id: mitcr_alpha_chain_file
  type: File
  outputSource: 
    mitcr_alpha_chain/mitcr_file

- id: mitcr_beta_chain_file
  type: File
  outputSource: 
    mitcr_beta_chain/mitcr_file

steps:
  
- id: combine_and_clean_fastqs
  run: steps/mitcr_combine_and_clean_fastqs/mitcr_combine_and_clean_fastqs.cwl 
  in: 
  - id: fastq_array
    source: [p1_fastq, p2_fastq]
  out: 
  - fastq

- id: mitcr_alpha_chain
  run: steps/mitcr/mitcr.cwl 
  in: 
  - id: input_fastq
    source: combine_and_clean_fastqs/fastq
  - id: output_file_string
    source: sample_name
    valueFrom: $(self + "_alpha_chain.txt")
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
    source: sample_name
    valueFrom: $(self + "_beta_chain.txt")
  out: 
  - mitcr_file
