#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python, /home/ubuntu/combineAndCleanFastq.py]

doc: "preprocessing before mitcr"

hints:
  DockerRequirement:
    #dockerPull: quay.io/cri-iatlas/combine_and_clean_fastqs
    dockerPull: combine_and_clean_fastqs

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: $(inputs.input_dir.listing)


inputs:

  input_dir:
    type: Directory
    inputBinding:
      position: 1
    doc: fastq file in the format of ".fastq" or ".fq"

outputs:

  output_file:
    type: File
    outputBinding:
      glob: "*reads.fq"
    doc: see output_dir_string

arguments:
  - valueFrom: $(runtime.outdir)
    position: 2

