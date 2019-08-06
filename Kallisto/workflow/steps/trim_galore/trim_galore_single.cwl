#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- /usr/local/bin/trim_galore

hints:
- class: ResourceRequirement
  coresMin: 1
  ramMin: 10000
- class: DockerRequirement
  dockerPull: dukegcb/trim-galore:0.4.4

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

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
