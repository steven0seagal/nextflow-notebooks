#!/usr/bin/env nextflow

params.reads_bam = "${projectDir}/data/reads_mother.bam"
params.outdir    = "results_genomics"
// Accessory files
params.reference        = "${projectDir}/reference/ref.fasta"
params.reference_index  = "${projectDir}/reference/ref.fasta.fai"
params.reference_dict   = "${projectDir}/reference/ref.dict"
params.intervals        = "${projectDir}/reference/intervals.bed"



include { SAMTOOLS_INDEX } from './utils/index.nf'
include { GATK_HAPLOTYPECALLER } from './utils/haplotype_caller.nf'



workflow {

    ref_file        = file(params.reference)
    ref_index_file  = file(params.reference_index)
    ref_dict_file   = file(params.reference_dict)
    intervals_file  = file(params.intervals)
    bam = file(params.reads_bam)
    
    reads_bam_ch = Channel.fromPath(params.reads_bam)

    SAMTOOLS_INDEX (reads_bam_ch)
    // Call variants from the indexed BAM file
    GATK_HAPLOTYPECALLER(
        bam,
        SAMTOOLS_INDEX.out,
        ref_file,
        ref_index_file,
        ref_dict_file,
        intervals_file
    )
}