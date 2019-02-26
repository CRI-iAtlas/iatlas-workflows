#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

baseCommand: 
  - Rscript
  - /usr/local/bin/aggregate_cibersort_celltypes.R

hints:
  DockerRequirement:
    dockerPull: aggregate_cibersort_celltypes

inputs:

  cibersort_file: 
    type: File
    inputBinding:
      prefix: --cibersort_file

  output_file: 
    type: string
    default: "output.tsv"
    inputBinding:
      prefix: --output_file

outputs:

  cell_counts_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file)