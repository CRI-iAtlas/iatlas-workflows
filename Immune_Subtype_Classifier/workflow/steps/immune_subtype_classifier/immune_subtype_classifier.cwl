cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- Rscript
- /usr/local/bin/immune_subtype_classifier.R

doc: "Call Immune subtype classifier on expression data."

requirements:
- class: InlineJavascriptRequirement

hints:
- class: DockerRequirement
  dockerPull: quay.io/cri-iatlas/immune_subtype_clustering:1.0

inputs:

- id: input_file
  type: File
  inputBinding:
    prefix: --input_file

- id: output_file
  type: string
  default: "immune_subtypes.tsv"
  inputBinding:
    prefix: --output_name
      
- id: input_file_delimeter
  type: string
  default: "\t"
  inputBinding:
    prefix: --input_file_delimeter

- id: input_gene_column
  type: string
  default: "Hugo"
  inputBinding:
    prefix: --input_gene_column

outputs:

- id: immune_subtypes_file
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
