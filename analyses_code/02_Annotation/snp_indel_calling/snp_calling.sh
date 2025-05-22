#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J bcftools_snp_calling
#SBATCH -o bcftools_snp_calling.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools 
module load bcftools/1.20
module load bwa/0.7.18
module load samtools/1.20

REF="/home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta"
ILLUMINA_DIR="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina"
OUT_DIR="/home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/snp_calling"
READ1="${ILLUMINA_DIR}/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz"
READ2="${ILLUMINA_DIR}/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz"

mkdir -p "${OUT_DIR}"

bwa index -p "${OUT_DIR}/ref_index" "${REF}" 2> "${OUT_DIR}/index.log"

bwa mem "${OUT_DIR}/ref_index" "${READ1}" "${READ2}" | samtools sort -@ 4 -O BAM -o "${OUT_DIR}/aligned.bam"

samtools index "${OUT_DIR}/aligned.bam"

bcftools mpileup -Ou -f "${REF}" --annotate FORMAT/AD,FORMAT/DP "${OUT_DIR}/aligned.bam" | bcftools call -m -v --ploidy 1 -Oz -o "${OUT_DIR}/raw_variants.vcf.gz"

bcftools index "${OUT_DIR}/raw_variants.vcf.gz"


