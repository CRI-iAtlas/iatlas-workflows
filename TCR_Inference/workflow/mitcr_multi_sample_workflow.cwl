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

  fastq_nested_array: 
    type: 
      type: array
      items:
        type: array
        items: File

  sample_name_array: string[]

  output_file_name:
    type: string
    default: "mitcr_summary.tsv"
      
      
outputs:

  mitcr_summary_file: 
    type: File
    outputSource: 
    - combine_mitcr_files/combined_file

steps:

  scatter_mitcr:
    run: mitcr_workflow.cwl
    in: 
      fastq_array: fastq_nested_array
      sample_name: sample_name_array
    scatter: [fastq_array, sample_name]
    scatterMethod: dotproduct
    out: 
    - mitcr_summary_file

  combine_mitcr_files:
    run: steps/r_tidy_utils/combine_tabular_files.cwl
    in: 
      files: scatter_mitcr/mitcr_summary_file
      output_file_name: output_file_name
    out: 
    - combined_file
  





    
