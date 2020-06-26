#!/bin/bash


chr=$22

##Create input files
#bash create_rfmix_input.sh $chr
cp tmp_chr${chr}_snps_keep.txt ../test/rfmix_ouput/chr${chr}/snps.txt


#Run RFMix
RFMix_TrioPhased  -a ..test/rfmix_input/chr${chr}/alleles.txt \
                  -p ..test/rfmix_input/chr${chr}/classes.txt \
                  -m ..test/rfmix_input/chr${chr}/snp_locations.txt \
                  -co 1 -o ../test/rfmix_output/rfmix_chr${chr}/local_ancestry
