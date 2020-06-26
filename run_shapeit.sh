#!/bin/bash

nr_threads=8
shapeit_dir=/home/test/shapeit_input/genetic_map_hapmap/chr22.txt

file=/home/test/bard/BARD_chr22

# get chr from file
chr=`basename $file | cut -f2 -d'_' | sed 's/chr//'`

# I want this: /home/test/BARD_chr22.bim
# Filter for duplicates, non-zero position, and chromosome
cat get_valid_variants.R | R --vanilla --args ${file}.bim $chr


# Create PLINK input files
plink --bfile ${file} \
      --extract ../test/chr${chr}_snps.txt \
      --make-bed --out ../test/chr${chr}

# Run shapeit.
shapeit --input-bed  /home/test/chr${chr}.bed \
        /home/test/chr${chr}.bim \
        /home/test/chr${chr}.fam \
        --input-map /home/test/shapeit_input/genetic_map_hapmap/chr22.txt \
        --thread ${nr_threads} \
        --output-max  ../BARD_chr${chr}.haps \
        /home/test/chr${chr}.samples

