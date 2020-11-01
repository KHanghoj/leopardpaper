angsd=/home/genis/software/angsd/angsd


n=$1
out=tmpdstat_$n
chrs=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/all_cat_autosomes.bed
regions=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/mappability_repeat_catRef.regions
bams=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/bamsLeopCatMappedV2No4BadNo8DupNo2RelandAsianLeops.txt
anc=/home/leopard/users/krishang/mapping_cat/refs/Felis_catus.Felis_catus_9.0.dna_sm.toplevel.fa

chr=`head -$n $chrs | tail -1`
echo "will do abbababba for scaffold $chr"

$angsd -GL 2 -out $out -nThreads 20 -doAbbababa 1 -doCounts 1 -bam $bams -minmapQ 30 -minq 30 -r $chr -sites $regions -blockSize 5000000 -anc $anc

echo "finished abbababa for scaffold $chr written to $out.abbababa"
