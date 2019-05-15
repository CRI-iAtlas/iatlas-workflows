#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:
  
- id: fastq_array
  type: File[]

- id: kallisto_index_file
  type: File

- id: kallisto_threads
  type: int?

  
outputs:

- id: abundance_file
  type: File
  outputSource: kallisto/abundance_file

steps:

- id: trim_galore
  run: steps/trim_galore/trim_galore.cwl
  in: 
  - id: fastq_array
    source: fastq_array
  - id: paired 
    valueFrom: $( true )
  out:
  - trimmed_fastq_array

- id: kallisto
  run: steps/kallisto/quant.cwl
  in:
  - id: fastq_array
    source: trim_galore/trimmed_fastq_array
  - id: index
    source: kallisto_index_file
  - id: threads
    source: kallisto_threads
  - id: plaintext
    valueFrom: $( true )
  out: 
  - abundance_file

