# requies local cibersort Docker image:
# https://github.com/CRI-iAtlas/iatlas-tool-cibersort

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/cibersort_wrapper.R

doc: "run CIBERSORT"

requirements:
- class: InlineJavascriptRequirement

hints:
- class: DockerRequirement
  dockerPull: quay.io/cri-iatlas/cibersort:1.2.1

inputs:

- id: mixture_file
  type: File
  inputBinding:
    prefix: --mixture_file
  doc: Path to mixture matrix.

- id: sig_matrix_file
  type: File?
  inputBinding:
    prefix: --sig_matrix_file
  doc: Path to reference matrix.
  
- id: output_file
  type: string
  default: "cibersort_results.feather"
  inputBinding:
    prefix: --output_file
  
- id: input_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --input_file_type
  doc: one of ["feather", "tsv", "csv"]
  
- id: output_file_type
  type: string
  default: "feather"
  inputBinding:
    prefix: --output_file_type
  doc: one of ["feather", "tsv", "csv"]

- id: perm
  type: int?
  inputBinding:
    prefix: --perm
  doc: No. permutations; set to >=100 to calculate p-values (default = 0)

- id: no_quantile_normalization
  type: boolean
  default: true
  inputBinding:
    prefix: --no_quantile_normalization
  doc: "Quantile normalization of input mixture (default = TRUE)"

- id: absolute
  type: boolean?
  inputBinding:
    prefix: --absolute
  doc: Run CIBERSORT in absolute mode (default = FALSE).

- id: abs_method
  type: string?
  inputBinding:
    prefix: --abs_method
  doc: If absolute is set to TRUE, choose method 'no.sumto1' or 'sig.score'

outputs:

- id: cibersort_file
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