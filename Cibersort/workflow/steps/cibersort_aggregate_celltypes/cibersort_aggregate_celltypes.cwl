cwlVersion: v1.0
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

baseCommand: 
- Rscript
- /usr/local/bin/cibersort_aggregate_celltypes.R

hints:
- class: DockerRequirement
  dockerPull: quay.io/cri-iatlas/cibersort_aggregate_celltypes:1.2

inputs:

- id: cibersort_file 
  type: File
  inputBinding:
    prefix: --cibersort_file

- id: output_file 
  type: string
  default: "aggregated_cibersort_results.feather"
  inputBinding:
    prefix: --output_file
    
- id: input_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --input_file_type
    
- id: output_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --output_file_type

outputs:

- id: cell_counts_file
  type: File
  outputBinding:
    glob: $(inputs.output_file)

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb
