# https://raw.githubusercontent.com/Sage-Bionetworks/amp-workflows/develop/tools/star_align/star_align.cwl

cwlVersion: v1.0
class: CommandLineTool
label: STAR spliced alignment
doc: |
  STAR: Spliced Transcripts Alignment to a Reference.
  https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  "@id": "http://orcid.org/0000-0003-3777-5945"
  foaf:name: "Tazro Ohta"
  foaf:mbox: "mailto:inutano@gmail.com"

hints:

  - class: DockerRequirement
    #dockerPull: 'quay.io/sage-bionetworks/star_utils:1.0'
    dockerPull: scidap/star:v2.5.0b

baseCommand: ['STAR', '--runMode', 'alignReads']

arguments:

  - prefix: --outFileNamePrefix
    valueFrom: "$(runtime.outdir)/$(inputs.output_dir_name)"

inputs:

  - id: unaligned_reads_fastq
    label: Unaligned reads FASTQ
    doc: |
      paths to files that contain input read1 (and, if needed, read2)
    type: File[]
    inputBinding:
      prefix: --readFilesIn
      itemSeparator: ","

  - id: genome_dir
    label: Reference genome directory
    doc: |
      path to the directory where genome files are stored
    type: Directory
    inputBinding:
      prefix: --genomeDir

  - id: num_threads
    label: Number of threads
    doc: |
      defines the number of threads to be used for genome generation, it has
      to be set to the number of available cores on the server node.
    type: int
    default: 1
    inputBinding:
      prefix: --runThreadN

  - id: output_dir_name
    label: Output directory name
    doc: |
      Name of the directory to write output files in
    type: string
    default: "STAR"

  - id: output_sam_type
    label: Output reads SAM/BAM
    doc: |
      1st word: BAM: output BAM without sorting, SAM: output SAM without
      sorting, None: no SAM/BAM output, 2nd, 3rd: Unsorted: standard unsorted,
      SortedByCoordinate: sorted by coordinate. This option will allocate
      extra memory for sorting which can be specified by –limitBAMsortRAM
    type: string[]
    default: ["BAM", "Unsorted"]
    inputBinding:
      prefix: --outSAMtype

  - id: output_sam_unmapped
    label: Unmapped reads action
    doc: |
      1st word: None: no output, Within: output unmapped reads within the main
      SAM file (i.e. Aligned.out.sam). 2nd word: KeepPairs: record unmapped
      mate for each alignment, and, in case of unsorted output, keep it
      adjacent to its mapped mate. Only a↵ects multi-mapping reads.
    type: string
    default: "Within"
    inputBinding:
      prefix: --outSAMunmapped

  - id: two_pass_mode
    label: Two-pass mode option
    doc: |
      STAR will perform the 1st pass mapping, then it will automatically
      extract junctions, insert them into the genome index, and, finally,
      re-map all reads in the 2nd mapping pass. This option can be used with
      annotations, which can be included either at the run-time, or at the
      genome generation step
    type: string
    default: "Basic"
    inputBinding:
      prefix: --twopassMode

outputs:

  - id: aligned_reads_sam
    label: Aligned reads SAM
    type: File
    outputBinding:
      glob: "*Aligned.out.bam"