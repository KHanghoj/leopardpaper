o=output/beds_keep

for b in A1 A2 A3 B1 B2 B3 B4 C1 C2 D1 D2 D3 D4 E1 E2 E3 F1 F2
do
    cat ${o}/${b}.bed
done > ${o}/all.bed
~/software/bedops/bin/sort-bed ${o}/all.bed > ${o}/all_sorted.bed
