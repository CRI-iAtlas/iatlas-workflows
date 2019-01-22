#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/deconrnaseq.R]

doc: "run DeconRNASeq"

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/deconrnaseq

inputs:

  input_expression_file:
    type: File
    inputBinding:
      prefix: --input_expression_file
    doc: Path to input matrix of expression data, tab seperated. Measured mixture data matrix, genes (transcripts) e.g. gene counts by samples, . The user can choose the appropriate counts, RPKM, FPKM etc..

  input_signature_file:
    type: File
    inputBinding:
      prefix: --input_signature_file
    doc: Path to input matrix of signature data, tab seperated. Signature matrix from different tissue/cell types, genes (transcripts) by cell types. For gene counts, the user can choose the appropriate counts, RPKM, FPKM etc..
    
  output_file_string:
    type: string
    inputBinding:
      prefix: --output_file
    default: "./output_file.RDS"
    doc: path to write output file

  input_proportions_file:
    type: ["null", File]
    inputBinding:
      prefix: --input_proportions_file
    doc: Path to input matrix of proportion data, tab seperated. Proportion matrix from different tissue/cell types. Default is NULL.
    
  checksig: 
    type: ["null", boolean]
    inputBinding:
      prefix: --checksig
    doc: Whether the condition number of signature matrix should be checked. The default is False.
    
  known.prop: 
    type: ["null", boolean]
    inputBinding:
      prefix: --known.prop
    doc: Whether the proportions of cell types have been known in advanced for proof of concept. The default is False.
    
  use.scale: 
    type: ["null", boolean]
    inputBinding:
      prefix: --use.scale
    doc: Whether the data should be centered or scaled. The default is True.

  fig: 
    type: ["null", boolean]
    inputBinding:
      prefix: --fig
    doc: Whether to generate the scatter plots of the estimated cell fractions vs. the true proportions of cell types. The default is True.


outputs:

  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file_string)
    doc: see output_string



