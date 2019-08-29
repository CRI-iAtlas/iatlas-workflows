#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement

inputs:

- id: input_file
  type: File
- id: output_file
  type: string
- id: sample_name
  type: string
  
outputs:
 
- id: cell_counts_file
  type: File
  outputSource: postprocessing/cell_counts_file
   
steps:

- id: preprocessing
  run: steps/r_tidy_utils/format_expression_file.cwl
  in:
  - id: input_file
    source: input_file
  - id: sample_name
    source: sample_name
  out:
  - expression_file
  
- id: epic
  run: steps/epic/epic.cwl
  in:
  - id: input_expression_file
    source: preprocessing/expression_file
  out: 
  - epic_file
    
- id: postprocessing
  run: steps/epic_postprocessing/epic_postprocessing.cwl
  in:
  - id: input_epic_file
    source: epic/epic_file
  - id: output_file_string
    source: output_file
  out: 
  - cell_counts_file

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb

