setwd('C:/Users/riade/OneDrive - Uppsala universitet/Genome Analysis')

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library("DESeq2")

if (!requireNamespace("apeglm", quietly = TRUE)) {
  BiocManager::install("apeglm")
}

if (!requireNamespace("pheatmap", quietly = TRUE)) {
  BiocManager::install("pheatmap")
}

if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
  install.packages("BiocManager")
  BiocManager::install("EnhancedVolcano")
}

library("EnhancedVolcano")
library("ggplot2")
library("ggrepel")
library("pheatmap")
directory <- "C:/Users/riade/OneDrive - Uppsala universitet/Genome Analysis/Project/mapped_reads/"

sampleTable <- data.frame(
  sampleName = c("ERR1797969", "ERR1797970", "ERR1797971", "ERR1797972", "ERR1797973", "ERR1797974"),
  fileName = c("ERR1797969_aligned_counts.txt", "ERR1797970_aligned_counts.txt", "ERR1797971_aligned_counts.txt",
               "ERR1797972_aligned_counts.txt", "ERR1797973_aligned_counts.txt", "ERR1797974_aligned_counts.txt"),
  condition = c("Serum", "Serum", "Serum","BH", "BH", "BH")
)


ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = directory,
                                       design = ~ condition)

dds <- DESeq(ddsHTSeq)
res <- results(dds)
res
resultsNames(dds)
summary(res)
plotMA(res)

# VOLCANO PLOT
EnhancedVolcano(res,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'pvalue',
                pCutoff = 0.05,
                FCcutoff = 1.0,
                title = 'Differential Expression: BH vs Serum',
                subtitle = 'Volcano plot of RNA-Seq data')


sigGenes <- subset(res, padj < 0.05 & abs(log2FoldChange) >= 1)
head(sigGenes[order(sigGenes$log2FoldChange), ])      # most downregulated
head(sigGenes[order(-sigGenes$log2FoldChange), ])     # most upregulated



# HISTOGRAM GENE COUNTS
counts <- counts(dds, normalized=TRUE)
hist(log10(rowSums(counts + 1)), 
     breaks=50, 
     col="steelblue", 
     main="Histogram of Gene Counts (log10)", 
     xlab="log10 Total Counts per Gene")

# TOTAL NUMBER OF EXPRESSED GENES
sum(rowSums(counts) > 10)  
# TOTAL NUMBER OF GENES
nrow(counts)               

# HEATMAP
vsd <- vst(dds, blind = FALSE)
sampleDists <- dist(t(assay(vsd)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- colnames(vsd)
colnames(sampleDistMatrix) <- colnames(vsd)
pheatmap(sampleDistMatrix, clustering_distance_rows=sampleDists, clustering_distance_cols=sampleDists,
         main="Sample-to-sample Distance Heatmap")

