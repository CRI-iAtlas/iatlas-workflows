#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- usr/local/bin/md5sum_checker.R

doc: "check if MD5sums are the same"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.0

stdout: status.txt

inputs:

- id: file1
  type: File
  inputBinding:
    position: 1
  
- id: file2
  type: File
  inputBinding:
    position: 2
      
outputs:

- id: status
  type: stdout

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
