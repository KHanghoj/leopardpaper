#!/bin/bash

PLINK='/home/users/xiaodong/Software/plink_1.9/plink'
${PLINK} --bfile plink/${sample}.sort  --homozyg  --allow-extra-chr --out plink/output/${sample}.ROH.optimal --homozyg-kb 500


