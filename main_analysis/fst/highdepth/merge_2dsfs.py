import numpy as np
import sys
import os
d = sys.argv[1]
chroms_f = sys.argv[2]

with open(chroms_f, 'r') as fh:
    chroms = [line.rstrip() for line in fh]

samplenames_f = os.path.join(d,chroms[0]+".names")

with open(samplenames_f, 'r') as fh:
    samplenames = ['_'.join(line.rstrip().split()) for line in fh]

with open("2dsfs.names", 'w') as fh:
    print("\n".join(samplenames), file=fh)

mat = np.zeros((len(samplenames), 9))

for chrom in chroms:
    mat += np.loadtxt(os.path.join(d,chrom+".data"))

f="2dsfs.data"

np.savetxt(f, mat, fmt="%d")
