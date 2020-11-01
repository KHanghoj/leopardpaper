#!/bin/bash

OUTDIR="/home/leopard/users/patricia/heterozygosity_catmap_wInbreed"
REF="/home/leopard/users/krishang/mapping_cat/refs/Felis_catus.Felis_catus_9.0.dna_sm.toplevel.fa"
BAMLIST="/home/leopard/users/patricia/errorRates_catmap/leopard_catmap_bamlist.txt"
realSFS="/programs/albrecht/angsd/misc/realSFS"
sites="/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/mappability_repeat_inbreed_catRef.regions"
scaffolds="catmap_scaffolds.txt"

cat ${BAMLIST} | while read line
do
angsd -i "$line" -anc ${REF} -dosaf 1 -rf $scaffolds -sites $sites -minMapQ 30 -minQ 30 -P 2 -out ${OUTDIR}/$(basename "${line%.*}") \
-gl 2 -doMajorMinor 1 -doCounts 1 -setMinDepthInd 3 -uniqueOnly 1 -remove_bads 1
${realSFS} -fold 1 ${OUTDIR}/$(basename "${line%.*}").saf.idx > ${OUTDIR}/$(basename "${line%.*}")_est.ml
done

## collect all estimates into one file
awk '{print FILENAME, $0}' *_est.ml > all_est.ml

## modify the sample names to drop the _est.ml suffix
sed -i 's/_est.ml//g' all_est.ml
