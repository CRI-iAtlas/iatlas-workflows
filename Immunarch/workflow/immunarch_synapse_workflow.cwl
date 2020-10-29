#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement

doc: >
  Workflow for pulling input files for `immunarch` from 
  Synapse, running the analysis, and storing the output on
  Synapse. For more information on any given input parameter, 
  refer to the corresponding tool's CWL definition. 

inputs:
  synapse_config: File
  input_synapse_ids: string[]
  sample_names: string[]?
  output_parent_synapse_id: string
  output_file: string?
  output_file_type: string?

outputs: 

  - id: output_synapse_id
    type: string
    outputSource: syn_store/file_id

steps:

  - id: syn_get
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-get-tool.cwl
    scatter: synapseid
    in: 
      synapse_config: synapse_config
      synapseid: input_synapse_ids
    out:
      - filepath

  - id: immunarch
    run: steps/immunarch/immunarch.cwl
    in: 
      input_files: syn_get/filepath
      sample_names: sample_names
      output_file: output_file
      output_file_type: output_file_type
    out:
      - immunarch_metrics

  - id: syn_store
    run: https://raw.githubusercontent.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/v1.0/cwl/synapse-store-tool.cwl
    in: 
      - id: synapse_config
        source: synapse_config
      - id: file_to_store
        source: immunarch/immunarch_metrics
      - id: parentid
        source: output_parent_synapse_id
      - id: name
        source: output_file 
      # The following is commented out until the following PR is merged.
      # Only then can these arguments be used. Update the CWL URL accordingly.
      # https://github.com/Sage-Bionetworks-Workflows/dockstore-tool-synapseclient/pull/30
      # - id: used
      #   source: input_synapse_ids
      # - id: executed
      #   valueFrom: $(["https://github.com/CRI-iAtlas/iatlas-workflows/blob/v1.1/Immunarch/workflow/steps/immunarch/immunarch.cwl"])
    out: 
      - file_id

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4621-1589
    s:email: bruno.grande@sagebase.org
    s:name: Bruno Grande
