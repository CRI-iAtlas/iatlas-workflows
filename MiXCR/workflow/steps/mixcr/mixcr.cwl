#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand:
- mixcr
- analyze

arguments:
- $(inputs.mixcr_type)

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/mixcr:1.0

requirements:
  - class: InlineJavascriptRequirement


inputs:

- id: p1_fastq
  type: File
  inputBinding:
    position: 1

- id: p2_fastq
  type: File?
  inputBinding:
    position: 2

- id: sample_name
  type: string
  inputBinding:
    position: 3

- id: mixcr_type
  type: string
  default: "shotgun"

- id: report_name
  type: string
  default: "report.txt"
  inputBinding:
    prefix: --report

- id: receptor_type
  type: string?
  inputBinding:
    prefix: --receptor-type

- id: species
  type: string
  default: "hsa"
  inputBinding:
    prefix: --species

- id: starting_material
  type: string
  default: "rna"
  inputBinding:
    prefix: --starting-material


outputs:

- id: mixcr_TRA_file
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.TRA.txt")

- id: mixcr_TRB_file
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.TRB.txt")

- id: mixcr_IGH_file
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.IGH.txt")

- id: mixcr_IGL_file
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.IGL.txt")


