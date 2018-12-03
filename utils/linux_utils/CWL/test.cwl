#!/usr/bin/env cwl-runner
# Author: Andrew Lamb
cwlVersion: v1.0
class: Workflow

doc: 

requirements:
- class: ScatterFeatureRequirement

inputs:

  fasta_urls:
    type:
      type: array
      items: string

outputs: 

  fasta_files:
    type:
      type: array
      items: File
    outputSource: get_fasta_files/output

steps:
 
  get_fasta_files:
    run: wget.cwl
    in: 
      url: fasta_urls
    scatter: url
    scatterMethod: dotproduct
    out: [output]

