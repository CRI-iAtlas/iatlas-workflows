#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement

inputs:

- id: input_expression_file
  type: File

- id: output_file_string
  type: string
  default: "output_file.tsv"
  
outputs:
 
- id: cell_counts_file 
  type: File
  outputSource: epic_postprocessing/cell_counts_file
   

steps:

  epic:
    run: steps/epic/epic.cwl
    in:
    - id: input_expression_file
      source: input_expression_file
    out: 
    - epic_file
    
  epic_postprocessing:
    run: steps/epic_postprocessing/epic_postprocessing.cwl
    in:
    - id: input_epic_file
      source: epic/epic_file
    - id: output_file_string
      source: output_file_string
    out: 
    - cell_counts_file

