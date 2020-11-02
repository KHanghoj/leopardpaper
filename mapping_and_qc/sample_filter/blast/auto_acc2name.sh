#!/bin/bash

#Save accession IDs from table, efetch IDs and save ASN.1 file

input=$1
output=$2


# Samples read in based on first column of input
while read sample; do

# Accession ids per sample
while read acc; do

efetch -db nucleotide -id ${acc} -format asn.1 | grep "taxname\|common" | cut -d"\"" -f2 - | tr '\n' '\t' | cut -f1,2 >> species_tmp

done < <(sed '/#/d' ${input} | grep ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort |  rev | cut -d' ' -f1 | rev | sed '/^$/d' )
#done < <(sed '/#/d' ${input} | awk '$4 >=16115 && $3 >=90 {print $0}' | grep ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort |  rev | cut -d' ' -f1 | rev | sed '/^$/d' )

# Count, ACC, Sample name

sed '/#/d' ${input} | grep -w ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort | rev | cut -d' ' -f2 | rev | awk -v sample="$sample" '{print sample"\t"$0}' > count_tmp
sed '/#/d' ${input} | grep -w ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort | rev | cut -d' ' -f1 | rev > acc_tmp

#sed '/#/d' ${input} | awk '$4 >=16115 && $3 >=90 {print $0}' | grep -w ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort | rev | cut -d' ' -f2 | rev | awk -v sample="$sample" '{print sample"\t"$0}' > count_tmp
#sed '/#/d' ${input} | awk '$4 >=16115 && $3 >=90 {print $0}' | grep -w ${sample} | cut -f2 | sort | sed '/^$/d' | uniq -c | sort | rev | cut -d' ' -f1 | rev > acc_tmp

paste count_tmp acc_tmp species_tmp >> ${output}

rm species_tmp
rm count_tmp
rm acc_tmp

done < <(sed '/#/d' ${input} | awk -F'\t' '!a[$1]++ {print $1}' | sed '/^$/d')
#done < <(sed '/#/d' ${input} | awk '$4 >=16115 && $3 >=90 {print $0}' | awk -F'\t' '!a[$1]++ {print $1}' | sed '/^$/d')


# Other commands used before
#sed '/#/d' qc_fail_samples_hits.txt | awk -F'\t' '!a[$1]++ {print $1}' | sed '/^$/d' > samp_tmp
#sample=$(sed '/#/d' ${input} | awk 'NR==1{print $1}')





