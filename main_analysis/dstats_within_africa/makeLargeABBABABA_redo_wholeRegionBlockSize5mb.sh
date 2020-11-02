angsd=/home/genis/software/angsd/angsd
anc=/home/leopard/users/genis/ref/GCF_001857705.1_PanPar1.0_genomic.s.fna


$angsd -GL 2 -out $out -nThreads 20 -doAbbababa 1 -doCounts 1 -bam $bams -minmapQ 30 -minq 30 -rf $wholeregion -sites $whitelist -blockSize 5000000 -anc $anc

