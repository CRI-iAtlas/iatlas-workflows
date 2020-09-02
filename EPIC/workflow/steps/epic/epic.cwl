#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
- Rscript
- /usr/local/bin/epic.R

doc: "run EPIC"

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/epic:1.0

inputs:

- id: input_expression_file
  type: File
  inputBinding:
    prefix: --input_expression_file
  doc: Path to input matrix of microarray expression data, tab seperated. A matrix (nGenes x nSamples) of the genes expression from each bulk sample (the counts should be given in TPM or RPKM when using the prebuilt reference profiles). This matrix needs to have rownames telling the gene names (corresponds to the gene symbol in the prebuilt reference profiles (e.g. CD8A, MS4A1) - no conversion of IDs is performed at the moment).

- id: output_file_string
  type: string
  default: "./output_file.RDS"
  inputBinding:
    prefix: --output_file
  doc: Path to write output file

- id: reference
  type: string
  default: "TRef"
  inputBinding:
    prefix: --reference
  doc: One 'TRef', BRef'. 

- id: scaleExprs
  type: boolean
  default: true 
  inputBinding:
    prefix: --scaleExprs
  doc: Boolean telling if the bulk samples and reference gene expression profiles should be rescaled based on the list of genes in common between the them (such a rescaling is recommanded). Default = True.

- id: withOtherCells
  type: boolean
  default: true
  inputBinding:
    prefix: --withOtherCells
  doc: If EPIC should allow for an additional cell type for which no gene expression reference profile is available or if the bulk is assumed to be composed only of the cells with reference profiles. Default = True.

- id: constrainedSum
  type: boolean
  default: true
  inputBinding:
    prefix: --constrainedSum
  doc: Tells if the sum of all cell types should be constrained to be < 1. When withOtherCells=FALSE, there is additionally a constrain the the sum of all cell types with reference profiles must be > 0.99. Default = True.

- id: rangeBasedOptim
  type: boolean
  default: false
  inputBinding:
    prefix: --rangeBasedOptim
  doc: See documentation. Deafult = False.

outputs:

- id: epic_file
  type: File
  outputBinding:
    glob: $(inputs.output_file_string)
  doc: see output_string

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb



