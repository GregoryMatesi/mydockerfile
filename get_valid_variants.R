#Set parameters
args <- commandArgs(trailingOnly = TRUE)
file <- args[1]
chr  <- args[2]





out.variant.list <- paste0("../test/chr", chr, "_snps.txt")


#Read bim file
bim <- read.table(file, stringsAsFactors = F)

#Subset to variants on the relevant chromosomes
bim <- bim[bim$V1 == chr,]

#Subset to variants with non-zero positions
bim <- bim[bim$V4 != 0,]

#Subset to variants that do not have duplicate positions
dup.pos <- bim$V4[duplicated(bim$V4)]
if (length(dup.pos) > 0) {
  bim <- bim[!(bim$V4 %in% dup.pos),]
}

#Write list of variants to extract
write.table(bim$V2, out.variant.list,  sep="\t", quote=F, row.names=F, col.names=F)
