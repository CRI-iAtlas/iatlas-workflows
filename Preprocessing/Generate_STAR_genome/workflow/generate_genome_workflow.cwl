#!/usr/bin/env cwl-runner
# Author: Andrew Lamb
cwlVersion: v1.0
class: Workflow

doc: 

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:

  fasta_urls:
    type:
      type: array
      items: string

  gtf_url: string

outputs: 

  genome_dir:
    type: Directory
    outputSource: generate_genome/genome_dir


steps:

  get_fasta_files:
    run: steps/utils/wget.cwl
    in:
      - id: url
        source: "#fasta_urls"
    scatter: url
    scatterMethod: dotproduct
    out: [output]

  get_gtf_file:
    run: steps/utils/wget.cwl
    in:
      - id: url
        source: "#gtf_url"
    out: [output]
 
  unzip_fasta_files:
    run: steps/utils/gunzip2.cwl
    in:
      - id: files
        source: get_fasta_files/output
      - id: output_file_string
        valueFrom: "genome.fasta"
    out: [output]

  unzip_gtf_file:
    run: steps/utils/gunzip3.cwl
    in:
      - id: files
        source: get_gtf_file/output
      - id: output_file_string
        valueFrom: "genome.gtf"
    out: [output]

  generate_genome:
    run: steps/STAR/star_genome_generate.cwl
    in: 
      - id: genome_fasta
        source: unzip_fasta_files/output
      - id: genemodel_gtf
        source: unzip_gtf_file/output
    out: [genome_dir]

