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
 
- id: cell_score_file 
  type: File
  outputSource: mcpcounter_postprocessing/cell_score_file
   

steps:

- id: mcpcounter_preprocessing
  run: steps/r_tidy_utils/format_expression_file.cwl
  in:
  - id: input_file
    source: input_file
  - id: sample_name
    source: sample_name
  out:
  - expression_file
  
- id: mcpcounter
  run: steps/mcpcounter/mcpcounter.cwl
  in:
  - id: input_expression_file
    source: mcpcounter_preprocessing/expression_file
  - id: features_type
    valueFrom: "HUGO_symbols"
  out: 
  - mcpcounter_file
    
- id: mcpcounter_postprocessing
  run: steps/mcpcounter_postprocessing/mcpcounter_postprocessing.cwl
  in:
  - id: input_mcpcounter_file
    source: mcpcounter/mcpcounter_file
  - id: output_file
    source: output_file
  out: 
  - cell_score_file

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb

