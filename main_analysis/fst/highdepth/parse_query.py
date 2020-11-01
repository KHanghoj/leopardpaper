import sys
import itertools as it

samplenames_f = sys.argv[1]
outbase_f = sys.argv[2]

samplenames_file = outbase_f + ".names"
data_file = outbase_f + ".data"


with open(samplenames_f, 'r') as fh:
    samplenames = [line.rstrip() for line in fh]
## sample_pairs = list(it.combinations(samplenames, 2))
sample_pairs_idx = list(it.combinations(range(len(samplenames)), 2))
dic = {x:[0]*9 for x in sample_pairs_idx}

CONV={
    "0/0":0,
    "0/1":1,
    "1/1":2,
}


def get_gts(fields):
    l=[]
    for g in fields:
        try:
            l.append(CONV[g])
        except:
            l.append(None)
    return(l)


for idx, line in enumerate(sys.stdin):
    # if idx % 1000000 == 0:
    #     print(f"parsed {idx}", file=sys.stderr, end='\r')
    fields = line.rstrip().split()
    gts = get_gts(fields)
    for (x1, x2) in sample_pairs_idx:
        if (gts[x1] == None) or (gts[x2] == None):
           continue
        dic[(x1,x2)][gts[x1]*3 + gts[x2]] += 1

with open(samplenames_file, 'w') as fh_s, open(data_file, 'w') as fh_d:
    for (x1,x2), v in dic.items():
        a=" ".join(map(str, v))
        print(f"{samplenames[x1]} {samplenames[x2]}", file=fh_s)
        print(f"{a}", file=fh_d)


# 0   1  2 3  4  5   6  7  8
# 00 01 02 10 11 12  20 21 22

# 01 0*3 + 1
# 20 2*3 + 0
