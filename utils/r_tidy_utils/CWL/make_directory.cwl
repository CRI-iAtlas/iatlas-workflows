#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/make_directory.R

doc: "Put files into directory"

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/r_tidy_utils:1.0

inputs:

- id: file_array
  type: File[]
  inputBinding:
    prefix: --files
  
- id: output_dir_string
  type: string
  default: "file_dir"
  inputBinding:
    prefix: --output_dir_string
      
outputs:

- id: directory
  type: Directory
  outputBinding:
    glob: $(inputs.output_dir_string)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
