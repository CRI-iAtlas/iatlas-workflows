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
    dockerPull: mgibio/mixcr

requirements:
  - class: InlineJavascriptRequirement


inputs:

- id: input_file1
  type: File
  inputBinding:
    position: 1

- id: input_file2
  type: File?
  inputBinding:
    position: 2

- id: analysis_name
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

- id: TRA
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.TRA.txt")

- id: TRB
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.TRB.txt")

- id: IGH
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.IGH.txt")

- id: IGL
  type: File
  outputBinding:
    glob: $(inputs.analysis_name + ".clonotypes.IGL.txt")


