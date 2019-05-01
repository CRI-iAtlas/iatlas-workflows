#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

baseCommand: 
- gunzip
- -c

inputs:

- id: gziped_file
  type: File
  inputBinding:
    position: 1

outputs:

- id: file
  type: stdout

stdout: $(inputs.gziped_file.nameroot)

