#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: ExpressionTool

requirements:
- class: InlineJavascriptRequirement

inputs:

- id: directory
  type: Directory

outputs:

- id: file_array
  type: File[]


expression: |
  ${
    return {file_array: inputs.directory.listing}
  }
