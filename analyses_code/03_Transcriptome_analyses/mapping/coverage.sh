#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 04:00:00
#SBATCH -J read_coverage_summary
#SBATCH -o read_coverage_summary.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load samtools/1.20

ALIGNMENT_BH="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/BH"
ALIGNMENT_SERUM="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/Serum"
COVERAGE_OUT="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/coverage"

mkdir -p "$COVERAGE_OUT"


for bam in ${ALIGNMENT_BH}/*.bam; do
    sample=$(basename "$bam" .bam)
    samtools coverage "$bam" > "${COVERAGE_OUT}/${sample}_coverage.txt"
done


for bam in ${ALIGNMENT_SERUM}/*.bam; do
    sample=$(basename "$bam" .bam)
    samtools coverage "$bam" > "${COVERAGE_OUT}/${sample}_coverage.txt"
done

