#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

baseCommand: 
- Rscript
- /usr/local/bin/cibersort_aggregate_celltypes.R

  
hints:
  DockerRequirement:
    #dockerPull: quay.io/cri-iatlas/cibersort_aggregate_celltypes
    dockerPull: cibersort_aggregate_celltypes

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

  leukocyte_fractions: 
    type: double[]?
    inputBinding:
      prefix: --leukocyte_fractions

outputs:

  cell_counts_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file)
