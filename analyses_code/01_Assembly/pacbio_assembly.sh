#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J pacbio_assembly
#SBATCH -o pacbio_assembly.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools canu/2.2

canu -p efaecium -d ../data/01_Assembly/pacbio_assembly genomeSize=3m -pacbio /proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/genomics_data/PacBio/*.fastq.gz
