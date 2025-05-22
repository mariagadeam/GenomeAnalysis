#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 10:00:00
#SBATCH -J read_counting
#SBATCH -o read_counting.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load htseq/2.0.2
module load gffread

GFF="/home/mariagad/GenomeAnalysis/analyses_code/03_Transcriptome_analyses/mapping/annotated_canu.no_fasta.gff"
ALIGNMENT_BH="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/BH"
ALIGNMENT_Serum="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/Serum"


read_counts="/proj/uppmax2025-3-3/nobackup/mariagad/03_Transcriptome_analyses/mapped_reads/counted_reads"
mkdir -p "read_counts"

for bam_file in ${ALIGNMENT_BH}/*.bam; do
    sample=$(basename "${bam_file}" .bam)
    htseq-count -f bam -r pos -s yes --type CDS -i ID "${bam_file}" "${GFF}" > "read_counts/${sample}_counts.txt"
done

for bam_file in ${ALIGNMENT_Serum}/*.bam; do
    sample=$(basename "${bam_file}" .bam)
    htseq-count -f bam -r pos -s yes --type CDS -i ID "${bam_file}" "${GFF}" > "read_counts/${sample}_counts.txt"
done
