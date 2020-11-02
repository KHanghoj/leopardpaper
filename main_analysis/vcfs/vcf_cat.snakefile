##### see http://localhost:8888/notebooks/leopard/misc.ipynb#gen-config-joint_vcf-against-cat

BCFTOOLS="/home/krishang/software/bcftools/bcftools-1.9/bin/bcftools"
MIN_MQ=30
MIN_BQ=30
OUTMAIN=config["outmain"] # "/emc/kristian/leopard/vcfs/results"
REF=config["ref"]

## this is a filter used together with total depth and allele depth
BED = config["bed"]

print(OUTMAIN)
print(REF)
print(BED)

depths = ["10", "15"]
alleledepths = ["1", "2", "3"]

wildcard_constraints:
    sample = "|".join(config["samples"].keys()),
    chrom="|".join(config["chroms"]),
    dp = "|".join(depths),
    ad = "|".join(alleledepths),


rule all:
    input:
        os.path.join(OUTMAIN, "vcf_joint", "joint_call.bcf.gz"),
        expand(os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_{dp}_{ad}.bcf.gz"),
               dp=depths,
               ad=alleledepths),
        expand(os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_nomissing_{dp}_{ad}.bcf.gz"),
               dp=depths,
               ad=alleledepths),
        expand(os.path.join(OUTMAIN, "vcf", "{sample}.bcf.gz"), sample=config["samples"].keys()),
        os.path.join(OUTMAIN, "vcf", "merged_snps.bcf.gz"),
        expand(os.path.join(OUTMAIN, "vcf_filtered", "merged_snps_{dp}_{ad}.bcf.gz"),
               dp=depths,
               ad=alleledepths),

    shell:
        "ln -s -f {OUTMAIN} ."


rule gen_bcftools_genome_wide_indi:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        temp(os.path.join(OUTMAIN, "vcf", "{sample}_{chrom}.bcf.gz"))
    threads: 1
    shell:
        """{BCFTOOLS} mpileup -r {wildcards.chrom}  -B -Q {MIN_BQ}  -q {MIN_MQ} --threads {threads} -O u --fasta-ref {REF} --per-sample-mF -a FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR {input}  | {BCFTOOLS} call -Ob -o {output} --threads {threads} --multiallelic-caller
#{BCFTOOLS} index {output}
"""


rule concat_chroms_indi:
    input:
        expand(os.path.join(OUTMAIN, "vcf", "{{sample}}_{chrom}.bcf.gz"), chrom = config["chroms"])
    output:
        vcf=os.path.join(OUTMAIN, "vcf", "{sample}.bcf.gz"),
        idx=os.path.join(OUTMAIN, "vcf", "{sample}.bcf.gz.csi")
    shell: """
    {BCFTOOLS} concat --naive -Ob -o {output.vcf} {input}
    {BCFTOOLS} index {output.vcf}
    """

rule merge_indi:
    input:
        expand(os.path.join(OUTMAIN, "vcf", "{sample}.bcf.gz"), sample=config["samples"].keys())
    output:
        vcf=os.path.join(OUTMAIN, "vcf", "merged_snps.bcf.gz"),
        csi=os.path.join(OUTMAIN, "vcf", "merged_snps.bcf.gz.csi")
    shell: """
    {BCFTOOLS} merge --threads 3 -Ou {input} | {BCFTOOLS} view --threads 3 -v snps -Ob -o {output.vcf}
    {BCFTOOLS} index {output.vcf}
    """

### IMPORTANT & and | means within same sample. && and || checks all the samples.

rule filter_for_treemix_indi:
    input:
        vcf=os.path.join(OUTMAIN, "vcf", "merged_snps.bcf.gz"),
    output:
        vcf=os.path.join(OUTMAIN, "vcf_filtered", "merged_snps_{dp}_{ad}.bcf.gz"),
        idx=os.path.join(OUTMAIN, "vcf_filtered", "merged_snps_{dp}_{ad}.bcf.gz.csi"),
    threads: 3
    shell: """
    {BCFTOOLS} +setGT --threads {threads} -T {BED} -Ob -o {output.vcf} {input.vcf} -- -t q -n . -i  '(GT="hom" & FMT/DP<{wildcards.dp}) | (GT="het" & (FMT/AD[:0]<{wildcards.ad} | FMT/AD[:1]<{wildcards.ad} | FMT/DP<{wildcards.dp}))'
    {BCFTOOLS} index {output.vcf}
    """


rule gen_bamlist:
    input:
        config["samples"].values()
    output:
        os.path.join(OUTMAIN, "vcf_joint", "bam.list")
    run:
        with open(output[0], 'w') as fh:
            for x in input:
                print(x,file=fh)

rule gen_bcftools_genome_wide:
    input:
        rules.gen_bamlist.output[0]
    output:
        temp(os.path.join(OUTMAIN, "vcf_joint", "{chrom}.bcf.gz"))
    threads: 1
    shell: """
    {BCFTOOLS} mpileup -r {wildcards.chrom}  -B -Q {MIN_BQ}  -q {MIN_MQ} --threads {threads} -O u --fasta-ref {REF} -b {input} --per-sample-mF -a FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR  | {BCFTOOLS} call -Ob -o {output} --threads {threads} --multiallelic-caller --variants-only
    #{BCFTOOLS} index {output}
"""

rule concat_chroms:
    input:
        expand(os.path.join(OUTMAIN, "vcf_joint", "{chrom}.bcf.gz"), chrom = config["chroms"])
    output:
        vcf=os.path.join(OUTMAIN, "vcf_joint", "joint_call.bcf.gz"),
        idx=os.path.join(OUTMAIN, "vcf_joint", "joint_call.bcf.gz.csi")
    shell: """
    {BCFTOOLS} concat --naive -Ob -o {output.vcf} {input}
    {BCFTOOLS} index {output.vcf}
    """

### IMPORTANT & and | means within same sample. && and || checks all the samples.

rule filter_for_treemix:
    input:
        vcf=os.path.join(OUTMAIN, "vcf_joint", "joint_call.bcf.gz"),
    output:
        vcf=os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_{dp}_{ad}.bcf.gz"),
        idx=os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_{dp}_{ad}.bcf.gz.csi"),
    threads: 3
    shell: """
    {BCFTOOLS} +setGT --threads {threads} -T {BED} -Ob -o {output.vcf} {input.vcf} -- -t q -n . -i  '(GT="hom" & FMT/DP<{wildcards.dp}) | (GT="het" & (FMT/AD[:0]<{wildcards.ad} | FMT/AD[:1]<{wildcards.ad} | FMT/DP<{wildcards.dp}))'
    {BCFTOOLS} index {output.vcf}
    """

rule remove_sites_with_missing:
    input:
        os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_{dp}_{ad}.bcf.gz"),
    output:
        vcf=os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_nomissing_{dp}_{ad}.bcf.gz"),
        idx=os.path.join(OUTMAIN, "vcf_joint_filtered", "joint_call_nomissing_{dp}_{ad}.bcf.gz.csi"),
    shell: """
    {BCFTOOLS} view -Ob -o {output.vcf}  -e 'GT[*]=="mis"' {input}
    {BCFTOOLS} index {output.vcf}
    """
