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
  
outputs:
 
- id: cell_score_file 
  type: File
  outputSource: mcpcounter_postprocessing/cell_score_file
   

steps:

  mcpcounter:
    run: steps/mcpcounter/mcpcounter.cwl
    in:
    - id: input_expression_file
      source: input_expression_file
    - id: features_type
      valueFrom: "HUGO_symbols"
    out: 
    - mcpcounter_file
    
  mcpcounter_postprocessing:
    run: steps/mcpcounter_postprocessing/mcpcounter_postprocessing.cwl
    in:
    - id: input_mcpcounter_file
      source: mcpcounter/mcpcounter_file
    out: 
    - cell_score_file

