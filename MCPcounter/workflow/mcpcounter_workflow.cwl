#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:

  expression_file: File
  leukocyte_fractions: double[]?
  feature_type:
    type: string
    default: "HUGO_symbols"
  
outputs:
 
  cell_counts_file: 
    type: File
    outputSource: aggregate_cibersort_celltypes/cell_counts_file
   

steps:

  mcpcounter:
    run: steps/mcpcounter/mcpcounter.cwl
    in:
      mixture_file: expression_file
      feature_type: feature_type
    out: 
    - output_file
    
  format_mcpcounter_output:
    run: steps/format_mcpcounter_output/format_mcpcounter_output.cwl
    in:
      mcpcounter_file: mcpcounter/output_file
      leukocyte_fractions: leukocyte_fractions
    out: 
    - cell_counts_file

