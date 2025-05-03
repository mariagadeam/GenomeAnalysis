#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J read_counting
#SBATCH -o read_counting.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load htseq/2.0.2

GFF="/home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/annotation/annotated_canu.gff"
ALIGNMENT_BH="/home/mariagad/GenomeAnalysis/data/03_Transcriptome_analyses/mapped_reads/BH/aligned.bam"
ALIGNMENT_Serum="/home/mariagad/GenomeAnalysis/data/03_Transcriptome_analyses/mapped_reads/Serum/aligned.bam"

htseq-count -f bam ${ALIGNMENT_BH} ${GFF}
htseq-count -f bam ${ALIGNMENT_Serum} ${GFF}
