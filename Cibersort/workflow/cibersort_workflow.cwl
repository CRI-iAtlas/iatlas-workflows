#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb
# requies local cibersort Docker image:
# https://github.com/CRI-iAtlas/iatlas-tool-cibersort
cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:

  expression_file: File
  leukocyte_fraction: double?
  
outputs:
 
  cell_counts_file: 
    type: File
    outputSource: aggregate_cibersort_celltypes/cell_counts_file
   

steps:

  cibersort:
    run: steps/cibersort/cibersort.cwl
    in:
      mixture_file: expression_file
    out: 
    - cibersort_file
    
  aggregate_cibersort_celltypes:
    run: steps/cibersort_aggregate_celltypes/cibersort_aggregate_celltypes.cwl
    in:
      cibersort_file: cibersort/cibersort_file
      leukocyte_fraction: leukocyte_fraction
    out: 
    - cell_counts_file

