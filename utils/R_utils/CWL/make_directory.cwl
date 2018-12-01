#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/make_directory.R]

doc: "Put files into directory"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/tidy_utils

inputs:

  files:
    type:
      type: array
      items: File
    inputBinding:
      prefix: --files
  
  output_dir_string:
    type: string
    default: "file_dir"
    inputBinding:
      prefix: --output_dir_string
      
outputs:

  output_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir_string)