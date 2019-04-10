#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/mixcr_combine_and_clean_files.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mixcr_combine_and_clean_files

requirements:
  - class: InlineJavascriptRequirement


inputs:

  tcr_alpha_chain_file: 
    type: File
    inputBinding:
      prefix: --tcr_alpha_chain_file

  tcr_beta_chain_file: 
    type: File
    inputBinding:
      prefix: --tcr_beta_chain_file

  bcr_heavy_chain_file: 
    type: File
    inputBinding:
      prefix: --bcr_heavy_chain_file

  bcr_light_chain_file: 
    type: File
    inputBinding:
      prefix: --bcr_light_chain_file

  sample_name: 
    type: string
    inputBinding:
      prefix: --sample_name

outputs:

  cdr3_file:
    type: File
    outputBinding:
      glob: "cdr3.tsv"


