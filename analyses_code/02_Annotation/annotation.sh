#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 1:00:00
#SBATCH -J pacbio_annotation
#SBATCH -o pacbio_annotation.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools prokka/1.45-5b58020

prokka --outdir /home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/annotation \
       --prefix annotated_canu \
       --locustag PACBIO \
       --force \
       --cpus 2 \
       /home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta
