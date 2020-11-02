o=output/beds_keep
mkdir -p ${o}

for f in $(find output/combined_perChr/*gz)
do
    a=$(basename $f .pos.gz)
    echo "~/software/vir_python36/bin/python scripts/select_sites.py $f | ~/software/bedops/bin/bedops -m /dev/stdin > ${o}/${a}.bed"
done | parallel --resume --progress -j 10 --joblog ${o}/parallel.log
