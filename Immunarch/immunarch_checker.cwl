#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: ScatterFeatureRequirement

inputs:
  input_files_array: 
    type: 
      type: array
      items: 
        type: array
        items: File
  sample_names_array: 
    type:
      type: array
      items: 
        type: array
        items: string
  output_file: 
    type: string
  output_file_type: 
    type: string
  expected_output_file_array: 
    type: File[]
  output_status_array: 
    type: string[]

outputs:
  status: 
    type: File[]
    outputSource: md5sum/status

steps:
  
  - id: immunarch
    run: workflow/steps/immunarch/immunarch.cwl
    scatter:
      - input_files
      - sample_names
    scatterMethod: dotproduct
    in: 
      input_files: input_files_array
      sample_names: sample_names_array
      output_file: output_file
      output_file_type: output_file_type
    out:
      - immunarch_metrics
    
  - id: md5sum
    run: checker/md5sum_checker.cwl
    scatter:
      - file1
      - file2
      - output_status
    scatterMethod: dotproduct
    in: 
      file1: immunarch/immunarch_metrics
      file2: expected_output_file_array
      output_status: output_status_array
    out: 
      - status

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
