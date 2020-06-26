#!/bin/bash


chr=$22


cut -f2 -d' ' ../test/rfmix_input/genetic_map_tgp/chr${chr}.txt | sort -k1 > tmp_chr${chr}_map_sorted.txt
cat ../test/rfmix_input/tgp/chr${chr}.impute.legend | grep ^rs | sort -k2 > tmp_chr${chr}_tgp_sorted.txt
cat ../test/rfmix_input/tgp/chr${chr}.impute.legend | grep ^rs | sort -k2 | cut -f2 -d' ' | uniq -u > tmp_chr${chr}_tgp_unique.txt
join tmp_chr${chr}_map_sorted.txt tmp_chr${chr}_tgp_unique.txt > tmp_chr${chr}_unique.txt
join -1 1 -2 2 tmp_chr${chr}_unique.txt tmp_chr${chr}_tgp_sorted.txt > tmp_chr${chr}_tgp_mapped.txt


cat ../test/BARD_chr${chr}.haps | cut -f2-5 -d ' ' > tmp_chr${chr}_admixed.txt
python get_admixed_snps.py $chr


sed -e '1d'  ../test/rfmix_input/tgp/chr${chr}.impute.legend | cut -f2 -d' '  | sed "s/^/${chr}:/" > \
       tmp_chr${chr}_ref_snps.txt
paste tmp_chr${chr}_ref_snps.txt  ../test/rfmix_input/tgp/chr${chr}.impute.hap > \
       tmp_chr${chr}_ref_select.txt
python get_ref_haps.py $chr



python get_admixed_haps.py $chr 


paste -d' ' tmp_chr${chr}_admixed_haps.txt tmp_chr${chr}_ref_haps.txt  > tmp_chr${chr}_alleles.txt
sed 's/ //g' tmp_chr${chr}_alleles.txt > ../data/input/rfmix/chr${chr}/alleles.txt


nr_samples=`wc -l ../data/intermediate/shapeit_output/chr${chr}.samples | xargs | cut -f1 -d' '`
let "nr_samples=nr_samples-2"
python create_classes.py $chr $nr_samples


cut -f1 -d' ' tmp_chr${chr}_snps_keep.txt > tmp_chr${chr}_final_pos.txt
cut -f2-3 -d' ' ../test/rfmix_input/genetic_map_tgp/chr${chr}.txt | uniq > tmp_chr${chr}_pos_cm.txt
join -1 1 -2 1 tmp_chr${chr}_final_pos.txt tmp_chr${chr}_pos_cm.txt | cut -f2 -d' ' > ../data/input/rfmix/chr${chr}/snp_locations.txt
python create_snp_locations.py $chr
