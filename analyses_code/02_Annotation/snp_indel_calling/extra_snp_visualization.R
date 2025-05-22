snps <- read.table("snps_table.txt", header=TRUE)
snps$SNP_type <- paste(snps$REF, snps$ALT, sep=">")

# DOTPLOT SNP POSITIONS IN GENOME
plot(snps$POS, rep(1, nrow(snps)), 
     col="darkred", pch=16, 
     xlab="Genome Position", 
     ylab="", yaxt="n", 
     main="SNP Position Distribution")

# ONLY SINGLE NT CHANGES
snps <- snps[nchar(snps$REF) == 1 & nchar(snps$ALT) == 1, ]

# BARPLOT OF TRANSITIONS
snps$type <- paste(snps$REF, ">", snps$ALT, sep="")
snp_counts <- table(snps$type)
barplot(snp_counts, main="SNP Types (Transitions/Transversions)",
        xlab="SNP Type", ylab="Count", col="steelblue", las=2)