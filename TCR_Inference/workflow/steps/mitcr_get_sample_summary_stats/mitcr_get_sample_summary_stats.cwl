#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: 
- python3
- /usr/local/bin/sampleSummaryStats.py

hints:
  DockerRequirement:
#    dockerPull: quay.io/cri-iatlas/mitcr_get_sample_summary_stats
    dockerPull: mitcr_get_sample_summary_stats

requirements:
  - class: InlineJavascriptRequirement


inputs:

  cdr3_file: 
    type: File
    inputBinding:
      position: 1

  summary_file_string: 
    type: string
    default: "mitcr_summary.tsv"
    inputBinding:
      position: 2

outputs:

  mitcr_summary_file:
    type: File
    outputBinding:
      glob: $(inputs.summary_file_string)


