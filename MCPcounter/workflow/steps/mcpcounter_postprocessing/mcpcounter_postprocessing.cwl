#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/mcpcounter_postprocessing.R

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mcpcounter_postprocessing

inputs:

- id: input_mcpcounter_file
  type: File
  inputBinding:
    prefix: --input_mcpcounter_file
    
- id: output_file_string
  type: string
  inputBinding:
    prefix: --output_file
  default: "./output_file.tsv"

outputs:

- id: cell_score_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_string)



