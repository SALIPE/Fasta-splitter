#!/bin/bash
source ~/.py-venv/bin/activate

export RUST_BACKTRACE=full

REF_sars=~/Desktop/datasets/test_voc/train/reference/SARS-CoV2_wuhan_refseq.fasta 
REF_HIV=/home/salipe/Desktop/genomic-extractor/comparison_scripts/castor_hiv_data/hiv1_refseq.fasta

HIV_DATA=~/Desktop/genomic-extractor/comparison_scripts/castor_hiv_data/variants/train

REF_HBV=~/Desktop/datasets/HBV/refseq.fasta
HBV_DATA=~/Desktop/datasets/HBV/data/train

DATA_SOURCE=$HIV_DATA
mkdir -p $DATA_SOURCE/kmers

for variant in HIV1_A HIV1_B HIV1_C HIV1_D HIV1_F HIV1_G
do
	gramep get-only-kmers --rpath $REF_HIV\
		--spath $HIV_DATA/$variant.fasta \
		--save-path $DATA_SOURCE/kmers/ \
		--word $1 \
		--step 1 \
		-d ALL
	cp $HIV_DATA/$variant.fasta  $DATA_SOURCE/kmers/$variant
done


