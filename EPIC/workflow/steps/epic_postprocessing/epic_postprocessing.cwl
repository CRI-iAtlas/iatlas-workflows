#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/epic_postprocessing.R

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/epic_postprocessing:1.1

inputs:

- id: input_epic_file
  type: File
  inputBinding:
    prefix: --input_epic_file
    
- id: output_file_string
  type: string
  inputBinding:
    prefix: --output_file
  default: "output_file.tsv"

outputs:

- id: cell_counts_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_string)



