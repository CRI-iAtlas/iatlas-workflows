# requies local cibersort Docker image:
# https://github.com/CRI-iAtlas/iatlas-tool-cibersort

cwlVersion: v1.0
class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

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
  outputSource: aggregate_cibersort_celltypes/cell_counts_file
   

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

- id: cibersort
  run: steps/cibersort/cibersort.cwl
  in:
  - id: mixture_file
    source: preprocessing/expression_file
  out: 
  - cibersort_file
    
- id: aggregate_cibersort_celltypes
  run: steps/cibersort_aggregate_celltypes/cibersort_aggregate_celltypes.cwl
  in:
  - id: cibersort_file
    source: cibersort/cibersort_file
  - id: output_file
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

