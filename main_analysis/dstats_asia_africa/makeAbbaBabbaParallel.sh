echo "begin"

ANGSD=/home/genis/software/angsd/angsd
JACKKNIFE=/home/genis/software/angsd/R/jackKnife.R

dir=/home/leopard/users/genis/redo11052020collapsedMapped/Dstats_catoutgroup
chrs=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/all_cat_autosomes.bed
bams=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/bamsLeopCatMappedV2No4BadNo8DupNo2RelandAsianLeops.txt
inds=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/indsLeopCatMappedV2No4BadNo8DupNo2RelandAsianLeops.txt
regions=/home/leopard/users/genis/redo11052020collapsedMapped/infoFiles/mappability_repeat_inbreed2_depth_catRef.regions
anc=/home/leopard/users/krishang/mapping_cat/refs/Felis_catus.Felis_catus_9.0.dna_sm.toplevel.fa

nscaff=`wc -l $chrs | cut -f1 -d" "`


#echo `seq 1 $nscaff` | xargs -n1 -P18 bash $do1Scaff

for i in `seq 1 $nscaff`
do
    out=tmpdstat_${i}
    chr=`head -$i $chrs | tail -1`
    echo "$ANGSD -GL 2 -out $out -doAbbababa 1 -doCounts 1 -bam $bams -minmapQ 30 -minq 30 -r $chr -sites $regions -blockSize 5000000 -anc $anc"
done | xargs -L1 -I CMD -P 18 bash -c CMD


out=$dir/abbabaabaLeopCatMappedV2No4BadNo8DupNo2RelAndAsianLeopsNewFilters271020

# this will create one beagle file per scaffold called tmpbgl_1.beagle.gz (...) Then this concatenates all
echo "going to concatenate all scaffolds in $out.abbababa"

for i in `seq 1 $nscaff`
do
    cat tmpdstat_$i.abbababa >> $out.abbababa
    echo "done scaffold $i"
done

cat tmpdstat*.arg > $out.arg

rm tmpdstat*    

Rscript $JACKKNIFE file=$out.abbababa indNames=$inds outfile=$out.dstats
