#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: expression_file
  type: File

- id: cibersort_output_name
  type: string
  default: "cibersort.tsv"

- id: mcpcounter_output_name
  type: string
  default: "mcpcounter.tsv"

- id: epic_output_name
  type: string
  default: "epic.tsv"

- id: leukocyte_fractions
  type: double[]?


outputs: 

- id: cibersort_file
  type: File
  outputSource: cibersort/cell_counts_file

- id: epic_file
  type: File
  outputSource: epic/cell_counts_file

- id: mcpcounter_file
  type: File
  outputSource: combine_mcpcounter/combined_file

steps:

- id: split_files
  run: steps/r_tidy_utils/split_tabular_file.cwl
  in: 
  - id: file
    source: expression_file
  out:
  - file_array

- id: cibersort
  run: cibersort_workflow.cwl
  in:
  - id: expression_file
    source: expression_file
  - id:  leukocyte_fractions
    source: leukocyte_fractions
  - id: output_file
    source: cibersort_output_name
  out:
  - cell_counts_file

- id: mcpcounter
  run: mcpcounter_workflow.cwl
  in:
  - id: input_expression_file
    source: split_files/file_array
  scatter: input_expression_file
  out:
  - cell_score_file

- id: epic
  run: epic_workflow.cwl
  in:
  - id: input_expression_file
    source: expression_file
  - id: output_file_string
    source: epic_output_name
  out:
  - cell_counts_file

- id: combine_mcpcounter
  run: steps/r_tidy_utils/combine_tabular_files.cwl
  in:
  - id: files
    source: mcpcounter/cell_score_file
  - id: output_file_name
    source: mcpcounter_output_name
  out:
  - combined_file



