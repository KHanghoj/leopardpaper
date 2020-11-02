angsd=/home/genis/software/angsd/angsd


out=/home/casia16/leopard/ABBABABA/results_redo15052020collapsedMapped/largesampleWholeRegionBlockSize5mb_notinkelly
downsampled=/home/leopard/users/genis/regions/leopDownample_Nregions1000_sizePerRegion1e+05.region
wholeregion=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/autosomes.list
whitelist=/home/ryan/leopard/ref_regions/mappability_inbreeding_depth_repeat.regions
bams=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/bamsLeopReMapV2No4BadNo8DupNo2Rel.txt
anc=/home/leopard/users/genis/ref/GCF_001857705.1_PanPar1.0_genomic.s.fna


$angsd -GL 2 -out $out -nThreads 20 -doAbbababa 1 -doCounts 1 -bam $bams -minmapQ 30 -minq 30 -rf $wholeregion -sites $whitelist -blockSize 5000000 -anc $anc

