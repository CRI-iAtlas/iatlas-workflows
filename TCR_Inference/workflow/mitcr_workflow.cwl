#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: MiTCR workflow

requirements:
- class: SubworkflowFeatureRequirement

inputs:

  fastq_files: 
    type:
      type: array
      items: File
      
  mitcr_pset_string:
    type: string
    default: "flex"
  
  mitcr_output_string:
    type: string
    default: "mitcr_output.txt"
    
#  option not working at the moment

#  mitcr_report_string:
#    type: string
#    default: "mitcr_report.txt"
      
outputs:

  output_file: 
    type: File
    outputSource: [mitcr/output_file]


steps:

  make_fastq_directory:
    run: steps/make_directory/make_directory.cwl 
    in: 
      files: fastq_files
    out: [output_dir]
  
  combine_and_clean_fastqs:
    run: steps/combine_and_clean_fastqs/combine_and_clean_fastqs.cwl 
    in: 
      input_dir: make_fastq_directory/output_dir
    out: [output_file]

  mitcr:
    run: steps/MiTCR/mitcr.cwl 
    in: 
      input_fastq: combine_and_clean_fastqs/output_file
      pset_string: mitcr_pset_string
      output_string: mitcr_output_string
#      report_string: mitcr_report_string
    out: [output_file]
    