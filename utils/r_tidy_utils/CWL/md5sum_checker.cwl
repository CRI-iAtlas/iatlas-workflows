#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- usr/local/bin/md5sum_checker.R

doc: "check if MD5sums are the same"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils

stdout: status.txt

inputs:

  file1:
    type: File
    inputBinding:
      position: 1
  
  file2:
    type: File
    inputBinding:
      position: 2
      
outputs:

  status:
    type: stdout
