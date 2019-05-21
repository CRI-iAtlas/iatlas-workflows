#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- /usr/local/bin/trim_galore

hints:
  DockerRequirement:
    dockerPull: dukegcb/trim-galore

inputs:

- id: fastq
  type: File
  inputBinding: 
    position: 1
      
- id: no_report_file
  type: boolean
  default: true
  inputBinding: 
    prefix: --no_report_file

outputs:

- id: fastq
  type: File
  outputBinding:
    glob: "*trimmed.fq*"
