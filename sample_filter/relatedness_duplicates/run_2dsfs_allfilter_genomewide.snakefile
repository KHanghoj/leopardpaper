import itertools as it
ANGSD="/home/krishang/software/angsd/angsd"

## see http://localhost:8888/notebooks/leopard/relatedness.ipynb#

REF="/home/leopard/users/genis/ref/GCF_001857705.1_PanPar1.0_genomic.s.fna"
BASEQ=30
MAPQ =30
BAM_IN_DIR="/davidData/kristian/leopard/mapping_collapsed_all_bams"

SAMPLES = glob_wildcards(os.path.join(BAM_IN_DIR, "{s}.bam")).s
MY_SITES = "/home/leopard/users/krishang/bed_region/mappability_inbreeding_depth_repeat.regions"
OUTMAIN="/emc/kristian/leopard/duplicates_relatedness/results_allfilter_genomewide"
#print(list(it.combinations(SAMPLES, 2)))
rule all:
    input:
        os.path.join(OUTMAIN, "sfs_2d", "collected.txt"),
        #os.path.join(OUTMAIN, "sfs", "collected.txt")


rule per_sample_saf:
    input:
        bam=os.path.join(BAM_IN_DIR, "{s}.bam"),
    output:
        saf_idx = os.path.join(OUTMAIN, "safs", "{s}.saf.idx"),
        saf = os.path.join(OUTMAIN, "safs", "{s}.saf.gz"),
        saf_pos = os.path.join(OUTMAIN, "safs", "{s}.saf.pos.gz"),
        arg = os.path.join(OUTMAIN, "safs", "{s}.arg"),
    params:
        outbase = lambda wildcards, output: output.saf_idx.replace(".saf.idx", "")
    threads: 3
    shell:
        "{ANGSD}/angsd -i {input.bam} -out {params.outbase} -minMapQ {MAPQ} -minQ {BASEQ} -dosaf 1 -sites {MY_SITES} -anc {REF} -GL 2 -P {threads} 2> /dev/null"

rule sfs_2d:
    input:
        saf_idx1 = os.path.join(OUTMAIN, "safs", "{s1}.saf.idx"),
        saf_idx2 = os.path.join(OUTMAIN, "safs", "{s2}.saf.idx"),
    output:
        os.path.join(OUTMAIN, "sfs_2d", "{s1}_{s2}.sfs")
    threads: 80
    log:
        os.path.join(OUTMAIN, "sfs_2d", "{s1}_{s2}.log")
    shell:
        "{ANGSD}/misc/realSFS -P {threads} {input.saf_idx1} {input.saf_idx2} > {output} 2> {log}"


rule collect_2dsfs:
    input:
        expand(os.path.join(OUTMAIN, "sfs_2d", "{s[0]}_{s[1]}.sfs"), s=it.combinations(SAMPLES, 2))
    output:
        f=os.path.join(OUTMAIN, "sfs_2d", "collected.txt")
    run:
        import os
        import pandas as pd
        data = []
        names = []
        for x in input:
            name = os.path.basename(x).replace(".sfs", "")
            names.append(name)
            with open(x, 'r') as fh:
                t = fh.read()
                data.append([float(x) for x in t.rstrip().split()])
        a = pd.DataFrame(data, index=names, columns=["aaAA","aaAD","aaDD","adAA","adAD","adDD","ddAA","ddAD","ddDD"])

        a["r0"] = (a["aaDD"]+a["ddAA"])/a["adAD"]
        a["r1"] = a["adAD"] / (a.iloc[:,[1,2,3,5,6,7]].sum(1))
        a["king"] = (a["adAD"] - 2*a[["aaDD", "ddAA"]].sum(1)) / (a.iloc[:,[1,3,5,7]].sum(1) + 2*a["adAD"])
        a.to_csv(output.f, index=True, header=True, index_label="id", sep=" ")


rule sfs:
    input:
        saf_idx1 = os.path.join(OUTMAIN, "safs", "{s1}.saf.idx"),
    output:
        os.path.join(OUTMAIN, "sfs", "{s1}.sfs")
    threads: 10
    log:
        os.path.join(OUTMAIN, "sfs", "{s1}.log")
    shell:
        "{ANGSD}/misc/realSFS -P {threads} {input.saf_idx1} > {output} 2> {log}"



rule collect_sfs:
    input:
        expand(os.path.join(OUTMAIN, "sfs", "{s1}.sfs"), s1=SAMPLES)
    output:
        f=os.path.join(OUTMAIN, "sfs", "collected.txt")
    run:
        import os
        import pandas as pd
        data = []
        names = []
        for x in input:
            name = os.path.basename(x).replace(".sfs", "")
            names.append(name)
            with open(x, 'r') as fh:
                t = fh.read()
                data.append([float(x) for x in t.rstrip().split()])
        a = pd.DataFrame(data, index=names, columns=["aa","ad","dd"])
        a["het"] = a["ad"] / a.sum(1)
        a.to_csv(output.f, index=True, header=True, index_label="id", sep=" ")
