#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: ExpressionTool

requirements:
- class: InlineJavascriptRequirement

inputs:

- id: nested_array
  type:
    type: array
    items:
      type: array
      items: File

- id: length_filter
  type: int

outputs:

- id: array1
  type:
    type: array
    items:
      type: array
      items: File

- id: array2
  type:
    type: array
    items:
      type: array
      items: File

expression: |
  ${
    var array1 = []
    var array2 = []
    for (var i = 0; i < inputs.nested_array.length; ++i) {
      if(inputs.nested_array[i].length > inputs.size_filter){
        array1.push(inputs.nested_array[i]) 
      }
      else{
        array2.push(inputs.nested_array[i]) 
      }
    }
    return {array1: array1, array2: array2}
  }
