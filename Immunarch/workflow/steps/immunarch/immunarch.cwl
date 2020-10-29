#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
  - Rscript
  - /usr/local/bin/immunarch.R

doc: Calculate Immunarch metrics from immune repertoires.

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/immunarch:1.0

inputs:

  - id: input_files
    type: File[]
    inputBinding:
      prefix: --input_files
    doc: >
      Repertoire file paths (format detected automatically).
      Refer to `immunarch::repLoad` R package documentation
      for additional details on which formats are supported.
      Examples include MiXCR/MiTCR, ImmunoSeq, and IMGT.

  - id: sample_names
    type: string[]?
    inputBinding:
      prefix: --sample_names
    doc: >
      List of sample names matching the order of files
      given to the `--input_files` argument. This can be
      used to differentiate between different repertoires
      for a given sample (e.g., IGH vs IGK vs IGL). If
      omitted, the R script will default to using the 
      file basenames.

  - id: output_file
    type: string?
    default: immunarch.feather
    inputBinding:
      prefix: --output_file
    doc: >
      File path where the Immunarch metrics will be stored. 
      These metrics include: n_unique_clonotypes, n_clones, 
      chao1_diversity, true_diversity, gini_simpson_diversity, 
      inverse_simpson_diversity, gini_diversity, d50_diversity, 
      and dx_diversity. File format is specified using 
      `output_file_type`.

  - id: output_file_type
    type: string?
    default: feather
    inputBinding:
      prefix: --output_file_type
    doc: >
      File format of the output file. Possible options are
      'feather', 'csv', and 'tsv'. 

outputs:

  - id: immunarch_metrics
    type: File
    outputBinding:
      glob: $(inputs.output_file)
    doc: >
      See description for the `output_file` input parameter.

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande