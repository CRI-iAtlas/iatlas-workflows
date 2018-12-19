# https://raw.githubusercontent.com/pitagora-galaxy/cwl/master/tools/samtools/index_bam/samtools_index_bam.cwl

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/samtools:1.9--h46bd0b3_0

baseCommand: ["samtools", "index", "-b"]

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input_bam)

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

outputs:
  bam_index:
    type: File
    outputBinding:
      glob: "*bai"
