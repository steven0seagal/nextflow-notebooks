#!/usr/bin/env nextflow

params.reads_bam = "${projectDir}/data/reads_mother.bam"
params.outdir    = "results_genomics"

include { SAMTOOLS_INDEX } from './utils/index.nf'




workflow {

    reads_bam_ch = Channel.fromPath(params.reads_bam)

    SAMTOOLS_INDEX (reads_bam_ch)
}