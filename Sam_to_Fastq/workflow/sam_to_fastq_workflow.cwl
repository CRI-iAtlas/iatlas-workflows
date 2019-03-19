#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: sam to fastq workflow

requirements:
- class: ScatterFeatureRequirement

inputs:

  sam_file_array: File[]
  fastq_r1_name_array: string[]
  fastq_r2_name_array: string[]

outputs:

  fastq_nested_array:
    outputSource: scatter_sam_to_fastq/output
#    type: File[]
    type:
      type: array
      items:
        type: array
        items: File

steps:

  scatter_sam_to_fastq:
    run: sam_to_fastq.cwl
    in: 
      aligned_reads_sam: sam_file_array
      reads_r1_fastq: fastq_r1_name_array
      reads_r2_fastq: fastq_r2_name_array
    scatter: 
    - aligned_reads_sam
    - reads_r1_fastq
    - reads_r2_fastq
    scatterMethod: dotproduct
    out: 
    - output


