angsd=/home/krishang/software/angsd/angsd/angsd
chrs=autosomes.list
regions=mappability_inbreeding_depth_repeat.regions
bams=bamlist.txt
#$angsd sites index $regions
$angsd -GL 2 -out ibs -nThreads 6 -doMajorMinor 1 -bam $bams -minmapQ 30 -minq 30 -sites $regions -doCounts 1 -doIBS 1 -makeMatrix 1 -rf $chrs
## -rf $chrs
