#!/bin/bash
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 15:00:00
#SBATCH -J extra_snp_calling
#SBATCH -o extra_snp_calling.uppmax2025-3-3.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user maria.gadea-martinez.2280@student.uu.se

module load bioinfo-tools
module load bcftools/1.20
module load samtools/1.20
module load bwa/0.7.18
module load GATK/4.3.0.0
module load picard/3.1.1

REF="/home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta"
READS_DIR="/proj/uppmax2025-3-3/nobackup/snp_analysis/data"
OUT_DIR="/proj/uppmax2025-3-3/nobackup/mariagad/02_Annotation_downstream_analyses/snp_calling"

mkdir -p "${OUT_DIR}"


bwa index -p "${OUT_DIR}/ref_index" "${REF}" 2> "${OUT_DIR}/index.log"

for  forward_read in ${READS_DIR}/*_1.fq.gz; do
        sample=$(basename "${forward_read}" | sed 's/_1\.fq\.gz$//')
        reverse_read="${READS_DIR}/${sample}_2.fq.gz"

        # Alignment and sorting
        bwa mem -t 8 "${OUT_DIR}/ref_index" "${forward_read}" "${reverse_read}" | samtools sort -@ 8 -O BAM -o "${OUT_DIR}/${sample}_aligned.bam"
        # Indexing
        samtools index "${OUT_DIR}/${sample}_aligned.bam"
done

samtools merge -o "${OUT_DIR}/extra_aligned.bam" "${OUT_DIR}/aligned.bam" "${OUT_DIR}/SRR3306347_aligned.bam" "${OUT_DIR}/SRR3306348_aligned.bam" "${OUT_DIR}/SRR3306349_aligned.bam"

samtools faidx "${REF}"  -o /home/mariagad/GenomeAnalysis/data/01_Assembly/pacbio_assembly/efaecium.contigs.fasta.fai

bcftools mpileup --threads 8 -Ou -f "${REF}" --annotate FORMAT/AD,FORMAT/DP "${OUT_DIR}/extra_aligned.bam" | bcftools call --threads 8 -m -v --ploidy 1 -Oz -o "${OUT_DIR}/raw_variants.vcf.gz"

bcftools index --tbi "${OUT_DIR}/raw_variants.vcf.gz"

java -jar $PICARD CreateSequenceDictionary R=${REF} O=${REF%.fasta}.dict

gatk VariantsToTable -V "${OUT_DIR}/raw_variants.vcf.gz" \
   -F CHROM -F POS -F REF -F ALT -R "${REF}"\
   -O /proj/uppmax2025-3-3/nobackup/mariagad/02_Annotation_downstream_analyses/snp_calling/snps_table.txt
