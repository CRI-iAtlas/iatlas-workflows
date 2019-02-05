#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb


cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /usr/local/bin/call_clusters.R]

doc: "Call Immune subtype clusters on expression data."

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: immune_subtype_clustering

inputs:

  input_file:
    type: File
    inputBinding:
      prefix: --input_file

  output_name:
    type: string
    default: "immune_subtypes.tsv"
    inputBinding:
      prefix: --output_name
      
  input_file_delimeter:
    type: string?
    inputBinding:
      prefix: --input_file_delimeter

  num_cores:
    type: int?
    inputBinding:
      prefix: --num_cores
      
  ensemble_size:
    type: int?
    inputBinding:
      prefix: --ensemble_size

  log_expression:
    type: boolean?
    inputBinding:
      prefix: --log_expression

  combat_normalize:
    type: boolean?
    inputBinding:
      prefix: --combat_normalize

  malformed_sample_names:
    type: boolean?
    inputBinding:
      prefix: --malformed_sample_names


outputs:

  immune_subtypes_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
