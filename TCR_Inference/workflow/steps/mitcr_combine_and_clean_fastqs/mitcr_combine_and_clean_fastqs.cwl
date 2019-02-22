#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- python2
- /home/ubuntu/combineAndCleanFastq.py

doc: "preprocessing before mitcr"

hints:
  DockerRequirement:
    #dockerPull: quay.io/cri-iatlas/mitcr_combine_and_clean_fastqs
    dockerPull: mitcr_combine_and_clean_fastqs

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: $(inputs.fastq_directory.listing)


inputs:

  fastq_directory:
    type: Directory
    inputBinding:
      position: 1
    doc: fastq file in the format of ".fastq" or ".fq"

outputs:

  fastq:
    type: File
    outputBinding:
      glob: "*reads.fq"

arguments:
  - valueFrom: $(runtime.outdir)
    position: 2

