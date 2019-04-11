#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0

class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
  - entry: $(inputs.file)
    writable: true

baseCommand: 
- gzip

inputs:

- id: file
  type: File
  inputBinding:
    position: 1

outputs:

- id: gziped_file
  type: File
  outputBinding:
    glob: $(inputs.file.path + ".gz")

