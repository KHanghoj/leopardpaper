library(RcppCNPy)

estF <- npyLoad("/home/leopard/users/genis/inbreed_sites/results/leopardV3100kscafMaf005and7indsout.inbreed.sites.npy")
site <- scan("/home/leopard/users/genis/inbreed_sites/results/leopardV3100kscafMaf005and7indsout.sites",what="df")
lrt <- npyLoad("/home/leopard/users/genis/inbreed_sites/results/leopardV3100kscafMaf005and7indsout.lrt.sites.npy")
chr <- sub("_[0123456789]+$","",x=site)
pos <- as.integer(sub(".*_","",x=site))

chr1mb <- scan("/home/leopard/users/genis/inbreed_sites/data/1MbscaffoldNoMT.txt", what="ds")
k <- chr %in% chr1mb

estF <- estF[k]
lrt <- lrt[k]
chr <- chr[k]
pos <- pos[k]
maxPos <- tapply(pos,chr,max)

meanF <- tapply(estF,chr,mean)
lenF <- tapply(estF,chr,length)


badRegions <- function(ch, minF=-0.95, reg=50000){
    k <- chr == ch
    # get bad sites (meanF below minF and significantly deviating hwe)
    badpos <- pos[k][lrt[k] > 24 & estF[k] < minF]
    
    if(length(badpos)==0) return(data.frame(chr=ch, start=1, end=1))
    # get regions reg (default 50000) bp in both directions of bad sites                             
    badreg <- matrix(c(badpos-reg, badpos+reg), ncol=2)
    badreg[badreg<0] <- 1

    if(nrow(badreg)==1) return(data.frame(chr=ch,start= badreg[1,1], end= badreg[1,2]))
    # collapse overlapping regions
    badreg2 <- c()
    start <- badreg[1,1]
    end <- badreg[1,2]
    for(i in 2:nrow(badreg)){

        if(badreg[i,1]<end){
            end <- badreg[i,2]
        }else{
            badreg2 <- c(badreg2, start, end)
            start <- badreg[i,1]
            end <- badreg[i,2]
        }
    }

    badreg2 <- c(badreg2,start,end)
    
    badreg <- t(matrix(badreg2,nrow=2))
    #out <- cbind(rep(ch, nrow(badreg)), badreg)
    out <- data.frame(chr=rep(ch,nrow(badreg)), start = badreg[,1], end = badreg[,2])
    return(out) 
}



badbedl <- lapply(chr1mb, badRegions,minF=-0.95, reg=50000)

badbed <- do.call('rbind', badbedl)

allbed <- read.table("/home/leopard/users/genis/inbreed_sites/data/scaff1MbNoMtallPos.BED")


names(allbed) <- names(badbed)

lenghtbad <- tapply(badbed$end-badbed$start, badbed$chr, sum)

Nbadreg <- tapply(badbed$chr, badbed$chr, length)* (lenghtbad>0)

summarydf <- data.frame(chr=chr1mb, length=allbed$end,meanF=meanF,
                        proportionBad=lenghtbad/allbed$end,
                        Nbadregions=Nbadreg,
                        keep= !(lenghtbad/allbed$end > 0.2 | meanF < -0.2))

write.table(summarydf, "/home/leopard/users/genis/inbreed_sites/results/inbreedSummaryV3.tsv",
            col.names=TRUE, row.names=FALSE, quote=FALSE, sep="\t")


w <- order(meanF)
pdf("/home/leopard/users/genis/inbreed_sites/results/inbreedfilts1mbv3.pdf")
for(i in 1:length(w)){
     plot(pos[chr==names(meanF)[w[i]]],estF[chr==names(meanF)[w[i]]],pch=4,col="goldenrod",lwd=2,main=names(meanF)[w[i]],ylab="F",xlab="position")
	 p<-pos[chr==names(meanF)[w[i]]]
	 F<-estF[chr==names(meanF)[w[i]]]
	 win <- 200
	 fun<-function(x,w)
	    ( cumsum(as.numeric(x))[-c(1:w)]-rev(rev(cumsum(as.numeric(x)))[-c(1:w)])) / w
    lines(fun(p,win),fun(F,win))
     abline(v=badbed[badbed$chr==chr1mb[w[i]],]$start, col="darkred",lwd=3,lty=2)
     abline(v=badbed[badbed$chr==chr1mb[w[i]],]$end, col="darkred",lwd=3,lty=2)
     }
dev.off()


badbed <- badbed[badbed$end > 1,]

finalbadbed <- rbind(badbed, data.frame(chr=summarydf$chr[!summarydf$keep],
                                start=rep(1, sum(!summarydf$keep)),
                                end=summarydf$length[!summarydf$keep]))

write.table(finalbadbed, "/home/leopard/users/genis/inbreed_sites/results/blacklistInbreedSites_unmerged_unsorted.BED", col.names=FALSE, row.names=FALSE, quote=FALSE, sep="\t")

# this create blacklist, which then is merged and used to create whitelist with bedtools
