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

- id: trim_galore_paired
  run: steps/trim_galore/trim_galore.cwl
  in: 
  - id: fastq_array
    source: split_fastq_array/array1
  - id: paired 
    valueFrom: $( true )
  scatter: fastq_array
  out:
  - trimmed_fastq_array

- id: trim_galore_single
  run: steps/trim_galore/trim_galore.cwl
  in: 
  - id: fastq_array
    source: split_fastq_array/array2
  - id: paired 
    valueFrom: $( false )
  scatter: fastq_array
  out:
  - trimmed_fastq_array

- id: kallisto_paired
  run: steps/kallisto/quant.cwl
  in:
  - id: fastq_array
    source: trim_galore_paired/trimmed_fastq_array
  - id: index
    source: kallisto_index_file
  - id: threads
    source: kallisto_threads
  - id: plaintext
    valueFrom: $( true )
  scatter: fastq_array
  out: 
  - abundance_file

- id: kallisto_single
  run: steps/kallisto/quant.cwl
  in:
  - id: fastq_array
    source: trim_galore_single/trimmed_fastq_array
  - id: index
    source: kallisto_index_file
  - id: threads
    source: kallisto_threads
  - id: plaintext
    valueFrom: $( true )
  - id: is_single_end
    valueFrom: $( true )
  - id: fragment_length
    source: fragment_length
  - id: sd
    source: fragment_length_sd
  scatter: fastq_array
  out: 
  - abundance_file

- id: combine_kalisto_files
  run: steps/r_tidy_utils/combine_kalisto_files.cwl
  in:
  - id: abundance_files
    source: [kallisto_paired/abundance_file, kallisto_single/abundance_file]
    linkMerge: merge_flattened
  - id: sample_names
    source: sample_name_array
  - id: output_file_name
    source: output_file_name
  out: 
  - expression_file

