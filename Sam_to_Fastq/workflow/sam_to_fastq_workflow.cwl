#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: sam to fastq workflow

requirements:
- class: ScatterFeatureRequirement

inputs:

- id: sam_file_array
  type: File[]

- id: fastq_r1_name_array
  type: string[]

- id: fastq_r2_name_array
  type: string[]

outputs:

- id: r1_fastq
  outputSource: scatter_sam_to_fastq/r1_fastq
  type: File[]

- id: r2_fastq
  outputSource: scatter_sam_to_fastq/r2_fastq
  type: File[]


steps:

- id: scatter_sam_to_fastq
  run: steps/sam_to_fastq/sam_to_fastq.cwl
  in: 
  - id: aligned_reads_sam
    source: sam_file_array
  - id: reads_r1_fastq
    source: fastq_r1_name_array
  - id: reads_r2_fastq
    source: fastq_r2_name_array
  scatter: 
  - aligned_reads_sam
  - reads_r1_fastq
  - reads_r2_fastq
  scatterMethod: dotproduct
  out: 
  - r1_fastq
  - r2_fastq


