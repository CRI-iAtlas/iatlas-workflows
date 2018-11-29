#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/epic.R]

doc: "run EPIC"

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/iatlas-tool-epic

inputs:

  input_expression_file:
    type: File
    inputBinding:
      prefix: --input_expression_file
    doc: Path to input matrix of microarray expression data, tab seperated. A matrix (nGenes x nSamples) of the genes expression from each bulk sample (the counts should be given in TPM or RPKM when using the prebuilt reference profiles). This matrix needs to have rownames telling the gene names (corresponds to the gene symbol in the prebuilt reference profiles (e.g. CD8A, MS4A1) - no conversion of IDs is performed at the moment).

  output_file_string:
    type: string
    default: "./output_file.RDS"
    inputBinding:
      prefix: --output_file
    doc: Path to write output file

  reference_type:
    type: ["null", string]
    inputBinding:
      prefix: --reference_type
    doc: One of NULL, 'TRef', BRef', 'list'. If list, refProfiles, sigGenes args must be given. See documetation for full description. 

  ref_profiles_file:
    type: ["null", File]
    inputBinding:
      prefix: --ref_profiles_file
    doc: Path to input matrix of reference data, tab seperated. A matrix (nGenes x nCellTypes) of the reference cells genes expression (without the cancer cell type); the rownames needs to be defined as well as the colnames giving the names of each gene and reference cell types respectively.

  ref_profiles_variability_file:
    type: ["null", File]
    inputBinding:
      prefix: --ref_profiles_variability_file
    doc: Path to input matrix of reference variability data, tab seperated. A matrix (nGenes x nCellTypes) of the variability of each gene expression for each cell type, which is used to define weights on each gene for the optimization (if this is absent, we assume an identical variability for all genes in all cells) - it needs to have the same dimnames than refProfiles.

  sigGenes_string:
    type: ["null", string]
    inputBinding:
      prefix: --sigGenes_string
    doc: String converted into vector for mRNA_cell_sub, see documentation, ie. 'gene1,gene2,gene3'.

  mRNA_cell_string:
    type: ["null", string]
    inputBinding:
      prefix: --mRNA_cell_string
    doc: String converted into vector for mRNA_cell, see documentation, ie. 'Bcells,NKcells,otherCells,default;2,2.1,3.5,1'.

  mRNA_cell_sub_string:
    type: ["null", string]
    inputBinding:
      prefix: --mRNA_cell_sub_string
    doc: tring converted into vector for mRNA_cell_sub, see documentation, ie. 'Bcells,NKcells,otherCells,default;2,2.1,3.5,1'.

  scaleExprs: 
    type: ["null", boolean]
    inputBinding:
      prefix: --scaleExprs
    doc: Boolean telling if the bulk samples and reference gene expression profiles should be rescaled based on the list of genes in common between the them (such a rescaling is recommanded). Default = True.

  withOtherCells: 
    type: ["null", boolean]
    inputBinding:
      prefix: --withOtherCells
    doc: If EPIC should allow for an additional cell type for which no gene expression reference profile is available or if the bulk is assumed to be composed only of the cells with reference profiles. Default = True.

  constrainedSum: 
    type: ["null", boolean]
    inputBinding:
      prefix: --constrainedSum
    doc: Tells if the sum of all cell types should be constrained to be < 1. When withOtherCells=FALSE, there is additionally a constrain the the sum of all cell types with reference profiles must be > 0.99. Default = True.

  rangeBasedOptim: 
    type: ["null", boolean]
    inputBinding:
      prefix: --rangeBasedOptim
    doc: See documentation. Deafult = False.

outputs:

  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_file_string)
    doc: see output_string



