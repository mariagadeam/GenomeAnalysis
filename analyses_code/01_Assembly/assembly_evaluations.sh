#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J assembly_evaluation
#SBATCH -o assembly_evaluation.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools quast/5.0.2


CANU_ASSEMBLY="../data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta"  # PacBio assembly
SPADES_ASSEMBLY="../data/01_Assembly/hybrid_assembly/contigs.fasta"  # Hybrid assembly
OUT_DIR="../data/01_Assembly/evaluation"
mkdir -p ${OUT_DIR}

# PACBIO ASSEMBLY
quast.py \
    -o ../data/01_Assembly/evaluation/pacbio_evaluation \
    --label "Canu_PacBio" \
    ${CANU_ASSEMBLY}

# HYBRID ASSEMBLY
quast.py \
    -o ../data/01_Assembly/evaluation/hybrid_evaluation \
    --label "SPAdes_Hybrid" \
    ${SPADES_ASSEMBLY}
