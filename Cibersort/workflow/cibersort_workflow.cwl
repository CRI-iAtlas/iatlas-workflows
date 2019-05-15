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

- id: expression_file
  type: File

- id: leukocyte_fractions
  type: double[]?
  
- id: output_file
  type: string
  default: "output.tsv"


outputs:
 
- id: cell_counts_file 
  type: File
  outputSource: aggregate_cibersort_celltypes/cell_counts_file
   

steps:

- id: cibersort
  run: steps/cibersort/cibersort.cwl
  in:
  - id: mixture_file
    source: expression_file
  out: 
  - cibersort_file
    
- id: aggregate_cibersort_celltypes
  run: steps/cibersort_aggregate_celltypes/cibersort_aggregate_celltypes.cwl
  in:
  - id: cibersort_file
    source: cibersort/cibersort_file
  - id: leukocyte_fractions
    source: leukocyte_fractions
  - id: output_file
    source: output_file
  out: 
  - cell_counts_file

