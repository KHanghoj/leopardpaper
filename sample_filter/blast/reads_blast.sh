#!/bin/bash

sample=$1

#For Unmapped read BLASTING

#UNMAPPED () {
#samtools view -f4 /home/leopard/users/genis/qcmapping/bam/${sample}.bam | cut -f1,10 | awk '{print ">"$1"\n"$2}' - > /home/leopard/users/cindy/${sample}.unmapped_for_blast.out
#blastn -task megablast -db nt -query /home/leopard/users/cindy/${sample}.unmapped_for_blast.out -remote -out /home/leopard/users/cindy/${sample}.unmapped_blast.results
#blastn -task megablast -db nt -query /home/leopard/users/cindy/${sample}.unmapped_for_blast.out -outfmt 6 -max_target_seqs 1 -remote -out /home/leopard/users/cindy/${sample}.unmapped_blast.table
#}

# For mtDNA read BLASTING

#MTDNA () {
#samtools view /home/leopard/users/genis/qcmapping/bam/${sample}.bam "NC_010641.1" |  cut -f1,10 | awk '{print ">"$1"\n"$2}' - > /home/leopard/users/cindy/${sample}.mtdna_for_blast.out
#blastn -task megablast -db nt -query /home/leopard/users/cindy/${sample}.mtdna_for_blast.out -remote -out /home/leopard/users/cindy/${sample}.mtdna_blast.results
#blastn -task megablast -db nt -query /home/leopard/users/cindy/${sample}.mtdna_for_blast.out -remote -outfmt 6 -max_target_seqs 1 -out /home/leopard/users/cindy/${sample}.mtdna_blast.table
#}

MITOGENOME () {
blastn -task megablast -db nt -query /home/leopard/users/cindy/angsd_fasta/mtdna_fastas/african_leop_mtdna.fa -remote -outfmt 6 -out /home/leopard/users/cindy/mtdna/${sample}.mtdna_blast.table
}

#UNMAPPED &
#MTDNA &
MITOGENOME &
