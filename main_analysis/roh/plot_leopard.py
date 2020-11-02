#!/usr/bin/env python3
import sys
import os
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('agg')
#https://matplotlib.org/users/customizing.html#matplotlib-rcparams
matplotlib.rcParams['xtick.labelsize'] = 16
matplotlib.rcParams['ytick.labelsize'] = 16
matplotlib.rcParams['axes.labelsize'] = 16
matplotlib.rcParams['legend.fontsize'] = 14
matplotlib.rcParams['axes.titlesize'] = 16
matplotlib.rcParams['axes.axisbelow'] = True
## matplotlib.use('agg')
import matplotlib.pyplot as plt
import pysam
save_fig_dic = {
    "transparent": True,
    "bbox_inches": 'tight',
    "pad_inches": 0.01,
    "dpi": 300
}
save_fig_dic_nottrans = {
    "transparent": False,
    "bbox_inches": 'tight',
    "pad_inches": 0.01,
    "dpi": 300
}

conv = {
    (0,0): 0,
    (0,1): 1,
    (1,0): 1,     ## should not appear due to unphased data
    (1,1): 2,
    (None, None): None
}

def get_data(f, chrom, name):
    gt = []
    pos = []
    #print(f, chrom, name)
    with pysam.VariantFile(f) as fh:
        for rec in fh.fetch(chrom, None, None):
            if len(rec.alleles) != 2:
                continue
            if len(rec.alleles[0])!=1 or len(rec.alleles[1])!=1:
                continue
            gt.append(conv[rec.samples[name]["GT"]])
            pos.append(rec.pos)
    gt = np.asarray(gt)
    pos = np.asarray(pos)
    rm = (gt==None)
    #print(len(gt))
    return(pos[~rm], gt[~rm], gt[~rm]==1, gt[~rm]!=1)

def make_ax_line(pos, het, hom, height, ax, markersize=4):
    ax.plot(pos[hom], [height]*np.sum(hom), "|", color="blue", zorder=1, label="Hom", markersize=markersize)
    ax.plot(pos[het], [height]*np.sum(het), "|", color="red", zorder=2, label="Het/Hom", markersize=markersize)


# CHROMS = pd.read_csv("/home/leopard/users/krishang/mapping_cat/refs/Felis_catus.Felis_catus_9.0.dna_sm.toplevel.fa.fai", sep="\t", header=None).head(18)[0].to_list()
# SAMPLES = ["CYP47", "BR406"]
# BCF_all = "/emc/kristian/leopard/vcfs/results_cat_puma/vcf_filtered/merged_snps_10_{ad}.bcf.gz".format
CHROMS = pd.read_csv("/home/leopard/users/genis/ref/GCF_001857705.1_PanPar1.0_genomic.s.fna.fai", sep="\t", header=None).head(7)[0].to_list()
SAMPLES = ["3241", "4343", "4354", "7547", "7942"]

BCF_all = "/emc/kristian/leopard/vcfs/results/vcf_filtered/merged_snps_10_{ad}.bcf.gz".format

fig, ax = plt.subplots(ncols=1,nrows=len(SAMPLES), figsize=(15,5*len(SAMPLES)), sharex=True)
for idx2, sample in enumerate(SAMPLES):
    for idx, chrom in enumerate(CHROMS):
        pos, gt, het, hom = get_data(BCF_all(ad=1), chrom, sample)
        make_ax_line(pos, het, hom, -idx-.2, ax[idx2], markersize=8)
        pos, gt, het, hom = get_data(BCF_all(ad=3), chrom, sample)
        make_ax_line(pos, het, hom, -idx+.2, ax[idx2], markersize=8)
        # pos2, gt2, het2, hom2 = get_data(BCF(ad=1), chrom, sample)
        # make_ax_line(pos2, het2, hom2, -idx+.1, ax[idx2])
        # pos2, gt2, het2, hom2 = get_data(BCF(ad=3), chrom, sample)
        # make_ax_line(pos2, het2, hom2, -idx+.3, ax[idx2])
        ax[idx2].set_title(sample)
    ax[idx2].set_yticks(-np.arange(len(CHROMS)))
    ax[idx2].set_yticklabels(CHROMS)
ax[0].legend(labels=["Hom", "Het/Hom"])
ax[-1].set_xlabel("Genomic position")
fig.savefig("merged_leopard.png", **save_fig_dic_nottrans)
