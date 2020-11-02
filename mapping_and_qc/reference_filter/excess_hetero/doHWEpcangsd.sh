pcangsd=/home/genis/software/pcangsd2/pcangsd/pcangsd.py
#bgl=/home/leopard/users/genis/inbreed_sites/data/leopardV210kscafMaf01Nobadmap.beagle.beagle.gz
#out=/home/leopard/users/genis/inbreed_sites/results/leopardV210kscafMaf01Nobadmap
bgl=/home/leopard/users/genis/inbreed_sites/data/leopardV3100kscafMaf005and7indsout.beagle.gz
out=/home/leopard/users/genis/inbreed_sites/results/leopardV3100kscafMaf005and7indsout
 


python3 $pcangsd -beagle $bgl -kinship -sites_save -inbreedSites -o $out -threads 20 > $out.log
