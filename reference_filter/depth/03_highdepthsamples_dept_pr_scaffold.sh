#!/bin/bash

BAMS=bams_highdepth.txt
OUT=output/highdepth_perChr/
mkdir -p $OUT

MBscaf=`samtools view -H /emc/kristian/leopard/mapping_cat/results/bam/3241.bam | grep @SQ | cut -f 2,3 | sed -e 's/SN://g' -e 's/LN://g' | awk '$2>1e6' | cut -f 1 | grep -v "X"`
for i in $MBscaf
do
    echo angsd -howoften 1000000  -minMapQ 30 -minQ 30  -doCounts 1 -doDepth 1 -dumpCounts 1 -maxdepth 3000 -b $BAMS -out ${OUT}$i -r $i

done | xargs -L 1 -I CMD -P 10 bash -c CMD
