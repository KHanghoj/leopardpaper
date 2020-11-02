#!/bin/bash


while read sample; do

samtools view -o ${sample}_mtdna.bam /home/leopard/users/krishang/mapping_collapse/mapping_collapsed_all_bams/${sample}.bam NC_010641.1
samtools index ${sample}_mtdna.bam
angsd -dofasta 2 -doCounts 1 -sites ../chrs.txt -i ${sample}_mtdna.bam -out ${sample}_mtDNA

done < <(cat ../all_leopard_bams.list | rev | cut -d. -f2 | cut -d/ -f1 | rev)


