#!/bin/bash

output="/home/leopard/users/patricia/errorRates_catmap"
goodbam="/emc/kristian/leopard/mapping_cat/results/bam/4354.bam"
ref="/home/leopard/users/patricia/errorRates_catmap/4354_catmap_consensus.fa.gz"
anc="/home/leopard/users/krishang/mapping_cat/refs/Felis_catus.Felis_catus_9.0.dna_sm.toplevel.fa"
bamlist="/home/leopard/users/patricia/errorRates_catmap/leopard_catmap_bamlist.txt"
sites="/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/mappability_repeat_catRef.regions"
scaffolds="cat_scaffolds.txt"

angsd -i $goodbam -doCounts 1 -doFasta 2 -explode 1 \
-uniqueOnly 1 -remove_bads 1 -minMapQ 40 -minQ 40 -out $output/4354_catmap_consensus

samtools faidx $ref

angsd -doAncError 2 -anc $anc -ref $ref -rf $scaffolds -sites $sites -nThreads 10 -bam $bamlist \
-uniqueOnly 1 -remove_bads 1 -minMapQ 30 -minQ 30 -out $output/errorRate_leopard_catmap_Q30

Rscript /programs/albrecht/angsd/R/estError.R file="/home/leopard/users/patricia/errorRates_catmap/errorRate_leopard_catmap_Q30.ancError"
