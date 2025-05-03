#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J snp_summary
#SBATCH -o snp_summary.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load bcftools/1.20
module load python/3.12.7


DATA_DIR="/home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/snp_calling"
RAW_VCF="${DATA_DIR}/raw_variants.vcf.gz"
STATS_DIR="/home/mariagad/GenomeAnalysis/data/02_Annotation_downstream_analyses/snp_calling/stats"

mkdir -p "${STATS_DIR}"
mkdir -p "${STATS_DIR}/raw_plots"


echo -e "### Variant counts" > "${STATS_DIR}/variant_counts.txt"
echo -e "Total variants:\t$( zgrep -vc '^#' "${RAW_VCF}" )"      >> "${STATS_DIR}/variant_counts.txt"
echo -e "SNPs:\t$( bcftools view -v snps "${RAW_VCF}" | grep -vc '^#' )"      >> "${STATS_DIR}/variant_counts.txt"
echo -e "Indels:\t$( bcftools view -v indels "${RAW_VCF}" | grep -vc '^#' )"  >> "${STATS_DIR}/variant_counts.txt"


bcftools stats "${RAW_VCF}" > "${STATS_DIR}/raw.stats"
grep ^TSTV "${STATS_DIR}/raw.stats" > "${STATS_DIR}/ts_tv.txt"


bcftools query -f '%QUAL\n'       "${RAW_VCF}" | sort -n > "${STATS_DIR}/qual_distribution.txt"
bcftools query -f '%INFO/DP\n'    "${RAW_VCF}" | sort -n > "${STATS_DIR}/info_dp_distribution.txt"
bcftools query -f '%FORMAT/DP\n'  "${RAW_VCF}" | sort -n > "${STATS_DIR}/format_dp_distribution.txt"
