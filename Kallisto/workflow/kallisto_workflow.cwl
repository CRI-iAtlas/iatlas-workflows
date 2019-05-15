#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: fastq_nested_array
  type:
    type: array
    items:
      type: array
      items: File
        
- id: sample_name_array
  type: string[]

- id: output_file_name
  type: string
  default: "expression_file.tsv"

- id: kallisto_threads
  type: int?

- id: kallisto_index_file
  type: File

- id: fragment_length
  type: float
  default: 200

- id: fragment_length_sd
  type: float
  default: 30
  
outputs:

- id: expression_file
  type: File
  outputSource: combine_kalisto_files/expression_file

steps:

- id: split_fastq_array
  run: steps/expression_tools/split_file_array_by_length.cwl
  in:
  - id: nested_array
    source: fastq_nested_array
  - id: length_filter
    valueFrom: $( 1 )
  out:
  - array1
  - array2

- id: kallisto_paired_end
  run: kallisto_paired_end_workflow.cwl
  in: 
  - id: fastq_array
    source: split_fastq_array/array1
  - id: kallisto_index_file
    source: kallisto_index_file
  - id: kallisto_threads
    source: kallisto_threads
  scatter: fastq_array
  out:
  - abundance_file

- id: kallisto_single_end
  run: kallisto_single_end_workflow.cwl
  in: 
  - id: fastq_array
    source: split_fastq_array/array2
  - id: kallisto_index_file
    source: kallisto_index_file
  - id: kallisto_threads
    source: kallisto_threads
  - id: fragment_length
    source: fragment_length
  - id: fragment_length_sd
    source: fragment_length_sd
  scatter: fastq_array
  out:
  - abundance_file


- id: combine_kalisto_files
  run: steps/r_tidy_utils/combine_kalisto_files.cwl
  in:
  - id: abundance_files
    source: [kallisto_paired_end/abundance_file, kallisto_single_end/abundance_file]
    linkMerge: merge_flattened
  - id: sample_names
    source: sample_name_array
  - id: output_file_name
    source: output_file_name
  out: 
  - expression_file

