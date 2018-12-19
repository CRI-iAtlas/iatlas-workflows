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

  fasta_url: string
  fasta_output_name: string

outputs: 

  genome_indeces:
    type: File[]
    outputSource: generate_indeces/result


steps:

  get_fasta_file:
    run: steps/utils/wget.cwl
    in:
      - id: url
        source: "#fasta_url"
    out: [output]

  unzip_fasta_file:
    run: steps/utils/gunzip3.cwl
    in:
      - id: files
        source: get_fasta_file/output
      - id: output_file_string
        source: "#fasta_output_name"
    out: [output]

  generate_indeces:
    run: steps/BWA/index.cwl
    in: 
      - id: reference
        source: unzip_fasta_file/output
    out: [result]

