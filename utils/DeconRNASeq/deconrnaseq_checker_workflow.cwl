#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

inputs:

  input_expression_file: File
  input_signature_file: File
  output_file: File

outputs:

  status: 
    type: File
    outputSource: md5sum/status

steps:
  
  deconrnaseq: 
    run: workflow/steps/deconrnaseq/deconrnaseq.cwl
    in: 
      input_expression_file: input_expression_file
      input_signature_file: input_signature_file
    out: [output_file]
    
  md5sum:
    run: checker/md5sum_checker.cwl
    in: 
      file1: deconrnaseq/output_file
      file2: output_file
    out: [status]

  