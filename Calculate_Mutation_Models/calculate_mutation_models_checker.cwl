#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
  input_feature_file: File
  input_group_file: File
  input_mutation_file: File
  output_file: string
  input_file_type: string
  output_file_type: string
  num_significant_digits: int
  expected_output_file: File

outputs:
  status: 
    type: File
    outputSource: md5sum/status

steps:
  
  - id: calculate_mutation_models
    run: workflow/steps/calculate_mutation_models/calculate_mutation_models.cwl
    in: 
      input_feature_file: input_feature_file
      input_group_file: input_group_file
      input_mutation_file: input_mutation_file
      output_file: output_file
      input_file_type: input_file_type
      output_file_type: output_file_type
      num_significant_digits: num_significant_digits
    out:
      - mutation_models
    
  - id: md5sum
    run: checker/md5sum_checker.cwl
    in: 
      file1: calculate_mutation_models/mutation_models
      file2: expected_output_file
    out: 
      - status

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
