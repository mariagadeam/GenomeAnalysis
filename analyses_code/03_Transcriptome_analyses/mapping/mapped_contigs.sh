#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 10:00:00
#SBATCH -J count_mapped_reads
#SBATCH -o count_mapped_reads.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load samtools/1.20

ALIGNMENT_BH="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/BH"
ALIGNMENT_Serum="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/Serum"
RESULTS="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/"

for aligned in ${ALIGNMENT_BH}/*.bam; do
    sample=$(basename "${aligned}" .bam)
    samtools flagstat "$aligned" > "$RESULTS/${sample}_number_contigs.txt"
done

for aligned in ${ALIGNMENT_Serum}/*.bam; do
    sample=$(basename "${aligned}" .bam)
    samtools flagstat "$aligned" > "$RESULTS/${sample}_number_contigs.txt"
done
