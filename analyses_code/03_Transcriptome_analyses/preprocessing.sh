#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 5:00:00
#SBATCH -J processing_RNA
#SBATCH -o processing_RNA.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load FastQC/0.11.9
module load trimmomatic/0.39

# BH

RAW_DATA="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_BH"
OUT_RAW_FASTQC="../../data/03_Transcriptome_analyses/filtered_RNA/BH/fastqc_raw"
OUT_TRIMMED="../../data/03_Transcriptome_analyses/filtered_RNA/BH/trimmed_reads"
OUT_TRIMMED_FASTQC="../../data/03_Transcriptome_analyses/filtered_RNA/BH/fastqc_trimmed"
mkdir -p $OUT_RAW_FASTQC $OUT_TRIMMED $OUT_TRIMMED_FASTQC

fastqc -o $OUT_RAW_FASTQC $RAW_DATA/*.fastq.gz

for  forward_read in ${RAW_DATA}/trim_paired_*_pass_1.fastq.gz; do
	sample=$(basename "${forward_read}" | sed 's/trim_paired_\(.*\)_pass_1.fastq.gz/\1/')
	reverse_read="${RAW_DATA}/trim_paired_${sample}_pass_2.fastq.gz"

	trimmomatic PE -phred33 \
	  -trimlog "$OUT_TRIMMED_FASTQC/${sample}_trimlog.txt" \
	  ${forward_read} ${reverse_read} \
	  "$OUT_TRIMMED/${sample}_forward_paired.fq.gz" \
	  "$OUT_TRIMMED/${sample}_forward_unpaired.fq.gz" \
	  "$OUT_TRIMMED/${sample}_reverse_paired.fq.gz" \
	  "$OUT_TRIMMED/${sample}_reverse_unpaired.fq.gz" \
	  ILLUMINACLIP:$TRIMMOMATIC_HOME/adapters/TruSeq3-PE.fa:2:30:7 \
	  MINLEN:15
done

fastqc -o $OUT_TRIMMED_FASTQC $OUT_TRIMMED/*_paired.fq.gz

## SERUM

RAW_DATA_Serum="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/transcriptomics_data/RNA-Seq_Serum"
OUT_RAW_FASTQC_Serum="../../data/03_Transcriptome_analyses/filtered_RNA/Serum/fastqc_raw"
OUT_TRIMMED_Serum="../../data/03_Transcriptome_analyses/filtered_RNA/Serum/trimmed_reads"
OUT_TRIMMED_FASTQC_Serum="../../data/03_Transcriptome_analyses/filtered_RNA/Serum/fastqc_trimmed"
mkdir -p $OUT_RAW_FASTQC_Serum $OUT_TRIMMED_Serum $OUT_TRIMMED_FASTQC_Serum

fastqc -o $OUT_RAW_FASTQC_Serum $RAW_DATA_Serum/*.fastq.gz

for  forward_read in ${RAW_DATA_Serum}/trim_paired_*_pass_1.fastq.gz; do
        sample=$(basename "${forward_read}" | sed 's/trim_paired_\(.*\)_pass_1.fastq.gz/\1/')
        reverse_read="${RAW_DATA_Serum}/trim_paired_${sample}_pass_2.fastq.gz"

	trimmomatic PE -phred33 \
	  -trimlog "$OUT_TRIMMED_FASTQC_Serum/${sample}_trimlog.txt" \
	  ${forward_read} ${reverse_read} \
	  "$OUT_TRIMMED_Serum/${sample}_forward_paired.fq.gz" \
	  "$OUT_TRIMMED_Serum/${sample}_forward_unpaired.fq.gz" \
	  "$OUT_TRIMMED_Serum/${sample}_reverse_paired.fq.gz" \
	  "$OUT_TRIMMED_Serum/${sample}_reverse_unpaired.fq.gz" \
	  ILLUMINACLIP:$TRIMMOMATIC_HOME/adapters/TruSeq3-PE.fa:2:30:7 \
	  MINLEN:15
done

fastqc -o $OUT_TRIMMED_FASTQC_Serum $OUT_TRIMMED_Serum/*_paired.fq.gz
