#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/make_directory.R

doc: "Put files into directory"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils

inputs:

  file_array:
    type: File[]
    inputBinding:
      prefix: --files
  
  output_dir_string:
    type: string
    default: "file_dir"
    inputBinding:
      prefix: --output_dir_string
      
outputs:

  directory:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir_string)
