BEDTOOLS=/home/genis/software/bedtools2/bin/bedtools

bedall=/home/leopard/users/genis/inbreed_sites/data/scaff1MbNoMtallPos.BED

blacklist=/home/leopard/users/genis/inbreed_sites/results/blacklistInbreedSites
whitelist=/home/leopard/users/genis/inbreed_sites/results/whitelistInbreedSites

$BEDTOOLS sort -i ${blacklist}_unmerged_unsorted.BED > ${blacklist}_unmerged.BED
$BEDTOOLS merge -i ${blacklist}_unmerged.BED > ${blacklist}.BED

$BEDTOOLS subtract -a $bedall -b $blacklist.BED > $whitelist.BED



### R Check % sequence in blacklist / whitelist


whitelist <- read.table("/home/leopard/users/genis/inbreed_sites/results/whitelistInbreedSites.BED")
blacklist <- read.table("/home/leopard/users/genis/inbreed_sites/results/blacklistInbreedSites.BED")
alllist <- read.table("/home/leopard/users/genis/inbreed_sites/data/scaff1MbNoMtallPos.BED")

lenlist <- function(x) sum(as.numeric(x$V3 - x$V2))

lenlist(whitelist) / lenlist(alllist) # 0.9480168
lenlist(blacklist) / lenlist(alllist) # 0.05279217


lenlist(whitelist) / lenlist(alllist) + lenlist(blacklist) / lenlist(alllist) # 1.000809 above 1 bc some regions in blacklist span longer than chromosome length


#### Make bed files 0 indexed instead of 1 indexed (by subracting 1 from each value)
whitelist2 <- whitelist
whitelist2[,2:3] <- whitelist[,2:3] - 1
write.table(whitelist2, "/home/leopard/users/genis/inbreed_sites/results/whitelistInbreedSitesV2.BED", col.names=F, row.names=F, quote=F, sep="\t")

blacklist2 <- blacklist
blacklist2[,2:3] <- blacklist[,2:3] - 1
write.table(blacklist2, "/home/leopard/users/genis/inbreed_sites/results/blacklistInbreedSitesV2.BED", col.names=F, row.names=F, quote=F, sep="\t")


