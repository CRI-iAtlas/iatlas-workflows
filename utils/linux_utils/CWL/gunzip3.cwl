#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott
# see https://github.com/Sage-Bionetworks/rnaseqSim/blob/master/general_tools/gunzip.cwl

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [gunzip, -c]
stdout: $(inputs.output_file_string)

doc: "command line: gunzip. Note: gunzip is not a well behaved program by CWL standards. It creates a file in the input directory (not the output directory) and deletes the original file. Both of these are generally not allowed by CWL. This is a version of gunzip wrapper that works."

requirements:
  - class: InlineJavascriptRequirement

inputs:

  files:
    type: File
    inputBinding:
      position: 1
       
  output_file_string:
    type: string

outputs:

  output:
    type: File
    outputBinding:
      glob: $(inputs.output_file_string)
