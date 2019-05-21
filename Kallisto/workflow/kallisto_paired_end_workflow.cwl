#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:
  
- id: fastq1
  type: File

- id: fastq2
  type: File

- id: kallisto_index_file
  type: File

- id: kallisto_threads
  type: int?

  
outputs:

- id: abundance_tsv
  type: File
  outputSource: kallisto/abundance_tsv

steps:

- id: trim_galore
  run: steps/trim_galore/trim_galore_paired.cwl
  in: 
  - id: fastq1
    source: fastq1
  - id: fastq2
    source: fastq2
  out:
  - fastq1
  - fastq2 

- id: kallisto
  run: steps/kallisto/quant_paired.cwl
  in:
  - id: fastq1
    source: trim_galore/fastq1
  - id: fastq2
    source: trim_galore/fastq2
  - id: index
    source: kallisto_index_file
  - id: threads
    source: kallisto_threads
  out: 
  - abundance_tsv

