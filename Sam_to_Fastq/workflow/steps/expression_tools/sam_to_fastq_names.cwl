#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: ExpressionTool

requirements:
- class: InlineJavascriptRequirement

inputs:

- id: sam_file_array
  type: File[]

outputs:

- id: fastq_names_1
  type: string[]
- id: fastq_names_2
  type: string[]

expression: |
  ${
    var fastq_names_1 = []
    var fastq_names_2 = []
    for (var i = 0; i < inputs.sam_file_array.length; ++i) {
      var root = inputs.sam_file_array[i].nameroot
      fastq_names_1.push(root + "_p1.fastq")
      fastq_names_2.push(root + "_p2.fastq")
    }
    return {fastq_names_1: fastq_names_1, fastq_names_2: fastq_names_2}
  }
