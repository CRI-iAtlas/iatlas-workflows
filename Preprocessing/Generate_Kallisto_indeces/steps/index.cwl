#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

baseCommand: [ kallisto, index ]

hints:
  DockerRequirement:
    dockerPull: insilicodb/kallisto

inputs:
  
  index_file_string:
    type: string
    inputBinding:
      prefix: "--index"
    
  fasta_file:
    type: File
    inputBinding: 
      position: 1
   
outputs:
  index:
    type: File
    outputBinding:
      glob: $(inputs.index_file_string)