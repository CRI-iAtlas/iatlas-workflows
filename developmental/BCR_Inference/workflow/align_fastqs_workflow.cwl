#!/usr/bin/env cwl-runner
# Author: Andrew Lamb
cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:

  fasta_files:
    type:
      type: array
      items: File

  star_genome_dir: Directory

outputs: 

  bam_file:
    type: File
    outputSource: samtools_sort/sorted_bamfile

  bam_index:
    type: File
    outputSource: samtools_index/bam_index


steps:

  truncate_fastq_files:
    run: steps/utils/truncate_fastq.cwl
    in:
      - id: input_fastq
        source: "#fasta_files"
      - id: read_length
        valueFrom: $( 48 )
    scatter: input_fastq
    scatterMethod: dotproduct
    out: [output]
    
  star_align:
    run: steps/STAR/star_align_reads.cwl
    in:
      - id: unaligned_reads_fastq
        source: truncate_fastq_files/output
      - id: genome_dir
        source: "#star_genome_dir"
    out: [aligned_reads_sam]

  samtools_sort:
    run: steps/samtools/sort.cwl
    in: 
      - id: input_bam
        source: star_align/aligned_reads_sam
    out: [sorted_bamfile]
    
  samtools_index:
    run: steps/samtools/index.cwl
    in: 
      - id: input_bam
        source: samtools_sort/sorted_bamfile
    out: [bam_index]
    