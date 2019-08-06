#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/kallisto:1.0

baseCommand: 
- kallisto 
- quant
- --output-dir
- "./"

inputs:

- id: fastq_array
  type: File[]
  inputBinding: 
    position: 1

- id: index
  type: File
  inputBinding:
    prefix: --index

- id: threads
  type: int?
  inputBinding:
    prefix: --threads
      
- id: plaintext
  type: boolean?
  inputBinding:
    prefix: --plaintext
      
- id: is_single_end
  type: boolean?
  inputBinding:
    prefix: --single

- id: fragment_length
  type: float?
  inputBinding:
    prefix: --fragment-length

- id: sd
  type: float?
  inputBinding:
    prefix: --sd
     
outputs:

  abundance_file:
    type: File
    outputBinding:
      glob: "abundance.*"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
