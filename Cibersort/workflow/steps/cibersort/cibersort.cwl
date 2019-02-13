#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/cibersort_wrapper.R]

doc: "run CIBERSORT"

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: cibersort

inputs:

  mixture_file:
    type: File
    inputBinding:
      prefix: --mixture_file
    doc: Path to mixture matrix.

  sig_matrix_file:
    type: File?
    inputBinding:
      prefix: --sig_matrix_file
    doc: Path to reference matrix.

  perm:
    type: int?
    inputBinding:
      prefix: --perm
    doc: No. permutations; set to >=100 to calculate p-values (default = 0)

  no_quantile_normalization:
    type: boolean?
    inputBinding:
      prefix: --no_quantile_normalization
    doc: "Quantile normalization of input mixture (default = TRUE)"

  absolute:
    type: boolean?
    inputBinding:
      prefix: --absolute
    doc: Run CIBERSORT in absolute mode (default = FALSE).

  abs_method:
    type: string?
    inputBinding:
      prefix: --abs_method
    doc: If absolute is set to TRUE, choose method 'no.sumto1' or 'sig.score'

outputs:

  cibersort_file:
    type: File
    outputBinding:
      glob: "CIBERSORT-Results.txt"
    doc: see output_string



