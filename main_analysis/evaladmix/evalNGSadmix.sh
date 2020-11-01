EVALADMIX=/home/genis/software/evalAdmix/evalAdmix

bgl=/home/leopard/users/genis/redo11052020collapsedMapped/beagle/leopardV3MapCollapsedMapDepthInbreedRepeatScaff1MbNo4BabNo8DupNo2RelNo1Uga.beagle.gz

outdir=/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/results/evaladmix
resdir=/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/results/

for k in 2 3 4
do
    qfile=`find $resdir/$k | grep qopt_conv`
    ffile=`find $resdir/$k | grep fopt_conv`
    out=$outdir/evalNGSadmixLeopReMappedV3No2relNoUgK$k
    $EVALADMIX -beagle $bgl -qname $qfile -fname $ffile -P 20 -o $out.corres &> $out.log
done
