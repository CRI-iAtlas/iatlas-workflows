#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- /usr/local/bin/trim_galore
- --paired

hints:
- class: ResourceRequirement
  coresMin: 1
  ramMin: 10000
- class: DockerRequirement
  dockerPull: dukegcb/trim-galore:0.4.4

inputs:

- id: fastq1
  type: File
  inputBinding: 
    position: 1

- id: fastq2
  type: File
  inputBinding: 
    position: 2
      
- id: no_report_file
  type: boolean
  default: true
  inputBinding: 
    prefix: --no_report_file

outputs:

- id: trimmed_fastq1
  type: File
  outputBinding:
    glob: "*_val_1*"

- id: trimmed_fastq2
  type: File
  outputBinding:
    glob: "*_val_2*"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
