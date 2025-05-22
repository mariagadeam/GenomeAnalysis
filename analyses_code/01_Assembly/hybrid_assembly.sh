#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2 
#SBATCH -t 12:00:00        
#SBATCH -J hybrid_assembly
#SBATCH -o hybrid_assembly.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools spades/3.15.5

ILLUMINA_DIR="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/genomics_data/Illumina"
NANOPORE_DIR="/proj/uppmax2025-3-3/Genome_Analysis/1_Zhang_2017/genomics_data/Nanopore"
OUTPUT_DIR="../data/01_Assembly/hybrid_assembly"
mkdir -p ${OUTPUT_DIR}

spades.py \
    -o ${OUTPUT_DIR} \
    --pe1-1 ${ILLUMINA_DIR}/forward_paired.fq.gz \
    --pe1-2 ${ILLUMINA_DIR}/reverse_paired.fq.gz \
    --nanopore ${NANOPORE_DIR}/*.fasta.gz \
    --threads ${SLURM_NTASKS} \
    --memory 64                    
