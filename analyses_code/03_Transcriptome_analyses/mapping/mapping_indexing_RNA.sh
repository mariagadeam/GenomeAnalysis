#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 10:00:00
#SBATCH -J bcftools_map_index
#SBATCH -o bcftools_map_index.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load bcftools/1.20
module load bwa/0.7.18
module load samtools/1.20

#BH

REF="/home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta"

RAW_DATA="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH/"
OUT_DIR="/home/mariagad/GenomeAnalysis/data/03_Transcriptome_analyses/mapped_reads/BH"

mkdir -p "${OUT_DIR}"

# Reference Indexing
bwa index -p "${OUT_DIR}/ref_index" "${REF}" 2> "${OUT_DIR}/index.log"

for  forward_read in ${RAW_DATA}/trim_paired_*_pass_1.fastq.gz; do
        sample=$(basename "${forward_read}" | sed 's/trim_paired_\(.*\)_pass_1.fastq.gz/\1/')
        reverse_read="${RAW_DATA}/trim_paired_${sample}_pass_2.fastq.gz"


	# Reference Indexing
	bwa index -p "${OUT_DIR}/ref_index" "${REF}" 2> "${OUT_DIR}/index.log"

	# Alignment
	bwa mem "${OUT_DIR}/ref_index" "${forward_read}" "${reverse_read}" | samtools sort -@ 4 -O BAM -o "${OUT_DIR}/${sample}_aligned.bam"

	samtools index "${OUT_DIR}/${sample}_aligned.bam"

done

# Serum

RAW_DATA_Serum="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum/"
OUT_DIR_Serum="/home/mariagad/GenomeAnalysis/data/03_Transcriptome_analyses/mapped_reads/Serum"

mkdir -p "${OUT_DIR_Serum}"

bwa index -p "${OUT_DIR_Serum}/ref_index" "${REF}" 2> "${OUT_DIR_Serum}/index.log"

for  forward_read in ${RAW_DATA_Serum}/trim_paired_*_pass_1.fastq.gz; do
        sample=$(basename "${forward_read}" | sed 's/trim_paired_\(.*\)_pass_1.fastq.gz/\1/')
        reverse_read="${RAW_DATA_Serum}/trim_paired_${sample}_pass_2.fastq.gz"

	# Alignment
	bwa mem "${OUT_DIR_Serum}/ref_index" "${forward_read}" "${reverse_read}" | samtools sort -@ 4 -O BAM -o "${OUT_DIR_Serum}/${sample}_aligned.bam"

	samtools index "${OUT_DIR_Serum}/${sample}_aligned.bam"

done
