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
  default: "cibersort.feather"
- id: input_file_type
  type: string
  default: "feather"
- id: output_file_type
  type: string
  default: "feather"
- id: parse_method
  type: string
  default: "long_expression"
- id: expression_column
  type: string
  default: "expression"
- id: sample_column
  type: string
  default: "sample"

outputs:
 
- id: aggregated_cibersort_file
  type: File
  outputSource: aggregate_cibersort_celltypes/aggregated_cibersort_file
   

steps:

- id: preprocessing
  run: steps/r_tidy_utils/format_expression_file.cwl
  in:
  - id: input_file
    source: input_file
  - id: input_file_type
    source: input_file_type
  - id: parse_method
    source: parse_method
  - id: expression_column
    source: expression_column
  - id: sample_column
    source: sample_column
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
  - id: output_file_type
    source: output_file_type
  out: 
  - aggregated_cibersort_file

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb

