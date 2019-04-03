#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:
  
  fastq_nested_array:
    type:
      type: array
      items:
        type: array
        items: File
        
  sample_name_array: string[]
  kallisto_threads: int?
  kallisto_index_file: File
  
outputs:

  expression_file:
   type: File
   outputSource: combine_kalisto_files/expression_file

steps:

  trim_galore:
    run: steps/trim_galore/trim_galore.cwl
    in: 
      fastq_array: fastq_nested_array
      paired: 
        valueFrom: $( true )
    scatter: fastq_array
    out:
    - trimmed_fastq_array
  
  kallisto:
    run: steps/kallisto/quant.cwl
    in:
      fastq_array: trim_galore/trimmed_fastq_array
      index: kallisto_index_file
      threads: kallisto_threads
      plaintext: 
        valueFrom: $( true )
    scatter: fastq_array
    out: 
    - abundance_file

  combine_kalisto_files:
    run: steps/r_tidy_utils/combine_kalisto_files.cwl
    in:
      abundance_files: kallisto/abundance_file
      sample_names: sample_name_array
    out: 
    - expression_file

