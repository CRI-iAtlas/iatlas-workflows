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

  fastq_array:
    type: File[]
    inputBinding: 
      position: 1
      
  paired:
    type: boolean?
    inputBinding: 
      prefix: --paired


outputs:

  trimmed_fastq_array:
    type: File[]
    outputBinding:
      glob: "*.fq"
