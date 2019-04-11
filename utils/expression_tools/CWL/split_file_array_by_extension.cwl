#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: ExpressionTool

requirements:
- class: InlineJavascriptRequirement

inputs:

- id: file_array
  type: File[]
- id: file_extension
  type: string

outputs:

- id: array1
  type: File[]
- id: array2
  type: File[]

expression: |
  ${
    var array1 = []
    var array2 = []
    for (var i = 0; i < inputs.file_array.length; ++i) {
      if(inputs.file_array[i].nameext == inputs.file_extension){
        array1.push(inputs.file_array[i]) 
      }
      else{
        array2.push(inputs.file_array[i]) 
      }
    }
    return {array1: array1, array2: array2}
  }
