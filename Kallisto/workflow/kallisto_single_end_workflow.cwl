#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:
  
- id: fastq
  type: File

- id: kallisto_index_file
  type: File

- id: kallisto_threads
  type: int?

- id: fragment_length
  type: float
  default: 200

- id: fragment_length_sd
  type: float
  default: 30
  
outputs:

- id: abundance_tsv
  type: File
  outputSource: kallisto/abundance_tsv

steps:

- id: trim_galore
  run: steps/trim_galore/trim_galore_single.cwl
  in: 
  - id: fastq
    source: fastq
  out:
  - fastq

- id: kallisto
  run: steps/kallisto/quant_single.cwl
  in:
  - id: fastq
    source: trim_galore/fastq
  - id: index
    source: kallisto_index_file
  - id: threads
    source: kallisto_threads
  - id: fragment_length
    source: fragment_length
  - id: sd
    source: fragment_length_sd
  out: 
  - abundance_tsv

