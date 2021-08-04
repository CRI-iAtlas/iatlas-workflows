#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/query_gene_expression.R

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/iatlas_api:1.3

inputs:

- id: cohorts
  type: string[]?
  inputBinding:
    prefix: --cohorts
    
- id: entrez
  type: int[]?
  inputBinding:
    prefix: --entrez
    
- id: gene_types
  type: string[]?
  inputBinding:
    prefix: --gene_types
    
- id: max_rnaseq_expr
  type: double?
  inputBinding:
    prefix: --max_rnaseq_expr

- id: min_rnaseq_expr
  type: double?
  inputBinding:
    prefix: --min_rnaseq_expr
    
- id: samples
  type: string[]?
  inputBinding:
    prefix: --samples
    
outputs:

- id: output_file
  type: File
  outputBinding:
    glob: "gene_expression.feather"

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



