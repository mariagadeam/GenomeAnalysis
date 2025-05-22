#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J processing_reads
#SBATCH -o processing_reads.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load FastQC/0.11.9
module load trimmomatic/0.39

RAW_DATA="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina"
OUT_RAW_FASTQC="../data/01_Assembly/filtered_Illumina/fastqc_raw"
OUT_TRIMMED="../data/01_Assembly/filtered_Illumina/trimmed_reads"
OUT_TRIMMED_FASTQC="../data/01_Assembly/filtered_Illumina/fastqc_trimmed"
ADAPTERS="TruSeq3-PE.fa"  
mkdir -p $OUT_RAW_FASTQC $OUT_TRIMMED $OUT_TRIMMED_FASTQC

# QUALITY CHECK RAW READS
fastqc -o $OUT_RAW_FASTQC $RAW_DATA/*.fq.gz

# TRIMMING
INPUT_FORWARD="$RAW_DATA/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz"
INPUT_REVERSE="$RAW_DATA/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz"

trimmomatic PE -phred33 \
  -trimlog "$OUT_TRIMMED_FASTQC/trimlog.txt" \
  $INPUT_FORWARD $INPUT_REVERSE \
  "$OUT_TRIMMED/forward_paired.fq.gz" "$OUT_TRIMMED/forward_unpaired.fq.gz" \
  "$OUT_TRIMMED/reverse_paired.fq.gz" "$OUT_TRIMMED/reverse_unpaired.fq.gz" \
  ILLUMINACLIP:$ADAPTERS:2:30:7 \
  MINLEN:15

# QUALITY CHECK TRIMMED READS
fastqc -o $OUT_TRIMMED_FASTQC \
  "$OUT_TRIMMED/forward_paired.fq.gz" \
  "$OUT_TRIMMED/reverse_paired.fq.gz"
