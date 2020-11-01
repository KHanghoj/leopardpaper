#!/bin/bash

#parallel NGSadmixConv.sh beagle_test.beagle.gz {1} ::: {3..9}

NGSCONV=/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/scripts/NGSadmixConv.sh

bgl=/home/leopard/users/genis/redo11052020collapsedMapped/beagle/leopardV3MapCollapsedMapDepthInbreedRepeatScaff1MbNo4BabNo8DupNo2RelNo1Uga.beagle.gz

seq 2 6 | xargs -n1 -P2 $NGSCONV $bgl

#for k in `seq 2 6`
#do
#        $NGSCONV $bgl $k
#done
