REF = CAT or LEOPARD
SITES = "/home/leopard/users/krishang/bed_region/mappability_inbreeding_depth_repeat.regions"
angsd -bam bam.list -out outbase -minMapQ 30 -minQ 30 -dosaf 1 -sites $SITES -anc $REF -GL 2 -P {threads}
