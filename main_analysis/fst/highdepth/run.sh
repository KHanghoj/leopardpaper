vcfDir=/home/leopard/users/krishang/vcfs
vcf=$vcfDir/results_cat/vcf_filtered/merged_snps_10_3.bcf.gz
mkdir -p chroms

bcftools index --stats $vcf | cut -f 1  > chroms.txt
bcftools query -l $vcf > samplenames.txt
cat chroms.txt | while read line;
do
    echo "bcftools query -r ${line} -f '[%GT ]\n' ${vcf} | ~/software/vir_python36/bin/python parse_query.py samplenames.txt  chroms/${line}"
done > parallel.tasks


parallel -j 40 --resume --joblog parallel.log --progress   :::: parallel.tasks

~/software/vir_python36/bin/python merge_2dsfs.py chroms chroms.txt

~/software/R/R-3.6.1.kelly/my_install/bin/Rscript reich_fst.R
