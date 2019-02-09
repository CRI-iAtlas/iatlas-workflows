#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: SubworkflowFeatureRequirement
- class: StepInputExpressionRequirement

inputs:

  fastq_array: File[]
  sample_name: string
      
      
outputs:

  file1: 
    type: File
    outputSource: 
    - mitcr_alpha_chain/mitcr_file

  file2: 
    type: File
    outputSource: 
    - mitcr_beta_chain/mitcr_file


steps:

  make_fastq_directory:
    run: steps/make_directory/make_directory.cwl 
    in: 
      file_array: fastq_array
    out: 
    - directory
  
  combine_and_clean_fastqs:
    run: steps/combine_and_clean_fastqs/combine_and_clean_fastqs.cwl 
    in: 
      fastq_directory: make_fastq_directory/directory
    out: 
    - fastq

  mitcr_alpha_chain:
    run: steps/MiTCR/mitcr.cwl 
    in: 
      input_fastq: combine_and_clean_fastqs/fastq
      output_file_string: 
          valueFrom: "mitcr_alhpa.txt"
      gene: 
        valueFrom: "TRA"
    out: 
    - mitcr_file

  mitcr_beta_chain:
    run: steps/MiTCR/mitcr.cwl 
    in: 
      input_fastq: combine_and_clean_fastqs/fastq
      output_file_string: 
          valueFrom: "mitcr_beta.txt"
    out: 
    - mitcr_file

  combine_and_clean_mitcr_files:
    run: steps/combine_and_clean_mitcr_files/combine_and_clean_mitcr_files.cwl
    in: 
      alpha_chain_file: mitcr_alpha_chain/mitcr_file
      beta_chain_file: mitcr_beta_chain/mitcr_file
      sample_name: sample_name
    out: 
    - cdr3_file


  #get_mitcr_summary:




    
