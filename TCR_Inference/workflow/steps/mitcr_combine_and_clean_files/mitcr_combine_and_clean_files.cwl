#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/combine_and_clean_mitcr_files.R

hints:
  DockerRequirement:
#    dockerPull: quay.io/cri-iatlas/combine_and_clean_mitcr_files
    dockerPull: combine_and_clean_mitcr_files

requirements:
  - class: InlineJavascriptRequirement


inputs:

  alpha_chain_file: 
    type: File
    inputBinding:
      prefix: --alpha_chain_file

  beta_chain_file: 
    type: File
    inputBinding:
      prefix: --beta_chain_file

  sample_name: 
    type: string
    inputBinding:
      prefix: --sample_name

outputs:

  cdr3_file:
    type: File
    outputBinding:
      glob: "*reads.fq"


