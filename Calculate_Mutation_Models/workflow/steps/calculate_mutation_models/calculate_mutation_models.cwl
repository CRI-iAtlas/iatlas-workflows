#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: 
  - Rscript
  - /usr/local/bin/calculate_mutation_models.R

doc: >
  Using linear regression, this tool calculates the association
  between the mutation status of each given gene with each given
  feature. This association is performed within each given group.

hints:
  DockerRequirement:
    dockerPull: quay.io/cri-iatlas/calculate_mutation_models:1.4

inputs:

  - id: input_feature_file
    type: File
    inputBinding:
      prefix: --input_feature_file
    doc: >
      File providing the value of each feature for each sample.
      Three columns are required. See `feature_name_column`, 
      `feature_sample_column`, and `feature_value_column` for
      expected (default) column names. Otherwise, use these
      parameters to indicate the non-default column names.
      File format is specified using `input_file_type`.

  - id: input_group_file
    type: File
    inputBinding:
      prefix: --input_group_file
    doc: >
      File providing the group that each sample belongs to. 
      Two columns are required. See `group_sample_column` 
      and `group_name_column` for expected (default) column 
      names. Otherwise, use these parameters to indicate the 
      non-default column names. File format is specified using 
      `input_file_type`.

  - id: input_mutation_file
    type: File
    inputBinding:
      prefix: --input_mutation_file
    doc: >
      File providing the mutation status of each gene for each 
      sample. Three columns are required. See `mutation_name_columns`, 
      `mutation_sample_column`, and `mutation_status_column` for
      expected (default) column names. Otherwise, use these
      parameters to indicate the non-default column names.
      The `mutation_name_separator` parameter must be specified if
      multiple column headers are provided to `mutation_name_columns`.
      File format is specified using `input_file_type`.

  - id: input_file_type
    type: string?
    default: feather
    inputBinding:
      prefix: --input_file_type
    doc: >
      File format of the input files. Possible options are
      'feather', 'csv', and 'tsv'. 

  - id: output_file
    type: string?
    default: mutation_models.feather
    inputBinding:
      prefix: --output_file
    doc: >
      File path where the mutation models will be stored. The following
      columns are provided: mutation, group, feature, n_wt, n_mut, 
      p_value, fold_change, log10_pvalue, and log10_fold_change.
      File format is specified using `output_file_type`.

  - id: output_file_type
    type: string?
    default: feather
    inputBinding:
      prefix: --output_file_type
    doc: >
      File format of the output file. Possible options are
      'feather', 'csv', and 'tsv'. 

  - id: feature_sample_column
    type: string?
    default: sample
    inputBinding:
      prefix: --feature_sample_column
    doc: >
      Column header in the features input file 
      (`input_feature_file`) that lists the samples.

  - id: feature_name_column
    type: string?
    default: feature
    inputBinding:
      prefix: --feature_name_column
    doc: >
      Column header in the features input file 
      (`input_feature_file`) that lists the features.

  - id: feature_value_column
    type: string?
    default: value
    inputBinding:
      prefix: --feature_value_column
    doc: >
      Column header in the features input file 
      (`input_feature_file`) that lists the feature values.

  - id: group_sample_column
    type: string?
    default: sample
    inputBinding:
      prefix: --group_sample_column
    doc: >
      Column header in the groups input file 
      (`input_group_file`) that lists the samples.

  - id: group_name_column
    type: string?
    default: group
    inputBinding:
      prefix: --group_name_column
    doc: >
      Column header in the groups input file 
      (`input_group_file`) that lists the groups.

  - id: mutation_name_columns
    type: string[]?
    default: [mutation]
    inputBinding:
      prefix: --mutation_name_columns
    doc: >
      Column header in the mutations input file 
      (`input_mutation_file`) that lists the mutation
      identifiers. Multiple headers can be provided.

  - id: mutation_name_separator
    type: string?
    default: ":"
    inputBinding:
      prefix: --mutation_name_separator
    doc: >
      Character to use when combining multiple columns
      for `mutation_name_columns`.

  - id: mutation_sample_column
    type: string?
    default: sample
    inputBinding:
      prefix: --mutation_sample_column
    doc: >
      Column header in the mutations input file 
      (`input_mutation_file`) that lists the samples.

  - id: mutation_status_column
    type: string?
    default: status
    inputBinding:
      prefix: --mutation_status_column
    doc: >
      Column header in the mutations input file 
      (`input_mutation_file`) that lists the mutation
      status. The 'Wt' value in this column signifies
      wildtype status, whereas any other value is
      considered to signify mutant status.
    
  - id: num_significant_digits
    type: int?
    inputBinding:
      prefix: --num_significant_digits
    doc: >
      Number of significant digits for any floating point
      numbers in the output file.

outputs:

  - id: mutation_models
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
