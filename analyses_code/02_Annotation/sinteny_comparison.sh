#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J mummerplot_sinteny
#SBATCH -o mummerplot_sinteny.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools MUMmer/4.0.0rc1

mummer -mum -b -c /home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta /home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/sinteny/sequences/GCF_009734005.1_ASM973400v2_genomic.fna > mummer.mums

REF_LEN=$(awk '/^>/ { next} {len += length} END {print len}' /home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/sinteny/sequences/GCF_009734005.1_ASM973400v2_genomic.fna)
QUERY_LEN=$(awk '/^>/ { next} {len += length} END {print len}' /home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta)

mummerplot -x "[0:$REF_LEN]" -y "[0:$QUERY_LEN]" -p mummer mummer.mums --png

