import numpy as np
import pandas as pd
import sys
import glob
import os
f_globdir = "/emc/kristian/leopard/depths/cats/output"

def get_perc(d, low=0.01, high=0.99):
    fs = glob.glob(os.path.join(d, "*.depthGlobal"))
    nobs = np.loadtxt(fs[0]).shape[0]

    abc = np.zeros((nobs, ))

    for idx, f in enumerate(fs):
        abc += np.loadtxt(f).reshape(nobs,)

    low = np.sum(abc)*0.01
    high = np.sum(abc)*0.99

    low_val = np.min(np.where(np.cumsum(abc)>low))+1

    high_val = np.min(np.where(np.cumsum(abc)>high))+1
    return (low_val, high_val)

low = get_perc(os.path.join(f_globdir, "lowdepth_perChr"))
high = get_perc(os.path.join(f_globdir, "highdepth_perChr"))

f=sys.argv[1]
b = pd.read_csv(f, sep="\t")
chrom = os.path.basename(f)[:-7]
keep_low = (b["lowTotDepth"]>=low[0]) & (b["lowTotDepth"]<=low[1])
keep_high = (b["highTotDepth"]>=high[0]) & (b["highTotDepth"]<=high[1])



for site in b.loc[keep_low & keep_high, "pos"]:
    print(f"{chrom}\t{site-1}\t{site}\n")
