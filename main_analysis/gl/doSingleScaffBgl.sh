angsd=/home/genis/software/angsd/angsd


#dir=/home/leopard/users/genis/beagle
n=$1
bgl=tmpbgl_$n
chrs=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/autosomes.list
regions=/home/ryan/leopard/ref_regions/mappability_inbreeding_depth_repeat.regions
bams=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/bamsLeopReMapV2No4BadNo8DupNo2Rel.txt


chr=`head -$n $chrs | tail -1`
echo "will do beagle for scaffold $chr"


#$angsd -GL 2 -out $bgl -nThreads 3 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -bam $bams -minmapQ 30 -minq 30 -r $chr -minmaf 0.05

# use when we have whitelist
$angsd -GL 2 -out $bgl -nThreads 3 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -bam $bams -minmapQ 30 -minQ 30 -r $chr -sites $regions -minmaf 0.05 &> $bgl.log

echo "finished beagle for scaffold $chr written to $bgl.beagle.gz"
