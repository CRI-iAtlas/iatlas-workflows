#!/usr/bin/env cwl-runner
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: truncate_fastq.sh

requirements:
  - class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    #dockerPull: quay.io/cri-iatlas/ubuntu_utils
    dockerPull: ubuntu_utils

inputs:

  input_fastq:
    type: File
    inputBinding:
      position: 1

  output_fastq:
    type: string
    default: output.fastq
    inputBinding:
      position: 2

  read_length:
    type: int
    default: 48
    inputBinding:
      position: 3
     
outputs:

  output:
    type: File
    outputBinding:
      glob: $(inputs.output_fastq)
