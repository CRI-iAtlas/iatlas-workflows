#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb
# requies local cibersort Docker image:
# https://github.com/CRI-iAtlas/iatlas-tool-cibersort

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
  fastq_arrays:
    type:
      type: array
      items:
        type: array
        items: File
        
  sample_name_array: string[]
  kallisto_threads: int?
  kallisto_index_file: File
  
outputs:

  cell_counts_file: 
    type: File
    outputSource: cibersort/cell_counts_file
   

steps:

  process_fastqs:
    run: fastq_processing_workflow.cwl
    in: 
      fastq_arrays: fastq_arrays
      sample_name_array: sample_name_array
      kallisto_threads: kallisto_threads 
      kallisto_index_file: kallisto_index_file
    out:
    - expression_file

  cibersort:
    run: cibersort_workflow.cwl
    in: 
      expression_file: process_fastqs/expression_file
    out:
    - cell_counts_file
  


