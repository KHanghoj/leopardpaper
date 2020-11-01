source("/home/leopard/users/genis/dstats/getDstats.R")
library(data.table)

masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
master <- gsheet::gsheet2tbl(masterFile)
df <- as.data.frame(master)

dstatsdf <- fread("/home/leopard/users/genis/redo11052020collapsedMapped/Dstats_catoutgroup/abbabaabaLeopCatMappedV2No4BadNo8DupNo2RelAndAsianLeops.dstats.txt",
                  h=T, data.table=F,sep = "\t")
dstatsdf <- dstatsdf[,-ncol(dstatsdf)]


africa <- df$Serial_number[df$Serial_number%in%as.matrix(dstatsdf[,1:3])]
asia <- c(3042211, 3042212)

inds <- c(africa, asia)
pop <- c(df$RH_aggregated_locality[df$Serial_number%in%as.matrix(dstatsdf[,1:3])], rep("Asia",2))
pop <- c(pop, c("bad_asian",
                "Bengal_Tiger",
                "Lion",
                "Panthera_onca",
                "Snow_Leopard",
                "White_Bengal_Tiger"))

names(pop) <- c(inds, c("5382750","Bengal_Tiger",
                        "Lion",
                        "Panthera_onca",
                        "Snow_Leopard",
                        "White_Bengal_Tiger"))


pops <- c("Ghana",  "TanzaniaN", "TanzaniaW", "TanzaniaE", "Namibia", "Zambia")

pairs <- t(combn(pops, 2))
poptrees <- cbind(pairs, rep("Asia", nrow(pairs)))

hidepth <- df$Serial_number[df$`Low_or_Hi_depth?`=="hi"&df$Included_after_sampleQC=="yes"]
bad <- c("2523","3042212")

alldstats <- do.call(rbind,apply(poptrees, 1, getDstat3pop, dstatdf=dstatsdf, method=1, locIdx=pop, exclude=c(hidepth, bad)))
# alldstats$poptree <- as.factor(alldstats$poptree, levels = apply(poptrees,1,paste,collapse="."))

alldstats$poptree <- gsub(".",", ",alldstats$poptree,fixed=T)

medZ <- sapply(apply(poptrees,1,paste,collapse=", "), function(x) median(alldstats$Z[alldstats$poptree == x]))
ord <- order(medZ, decreasing=T)
alldstats$poptree <- factor(alldstats$poptree, levels = apply(poptrees,1,paste,collapse=", ")[ord])




bitmap("/home/leopard/users/genis/redo11052020collapsedMapped/dstats/jitterPlotDstatAsianOnlyLowDeNo2523New2.png",
    height=8, width=8, units="in",res=500)
#dev.new(height=10, width=10, units="in")
par(mar=c(5,14,8,2))
boxplot(alldstats$Dstat ~ alldstats$poptree,      
        boxwex=0.5,
        main="",
        horizontal=T,las=2,ylim=c(-0.05,0.05),xlab="",cex.axis=1.1, outline=F)
title(xlab="D statistic", line=4, cex.lab=1.4)
# make jitter point https://www.r-graph-gallery.com/96-boxplot-with-jitter.html
mylevels <- levels(alldstats$poptree)
levelProportions <- summary(alldstats$poptree) / nrow(alldstats)

abline(v=0, lty=2)

for(i in 1:length(mylevels)){
  
  lev <- mylevels[i]
  values <- alldstats[alldstats$poptree==lev,]
  
  myjit <- jitter(rep(i, nrow(values)), amount=levelProportions[i]/2)
  points(y=myjit, x=values$Dstat, col=ifelse(abs(values$Z)>3, "goldenrod", "grey"), pch=20)
  
}
legend(x=0.02, y=14, legend=c("|Z score| < 3", "|Z score| > 3"), col=c("grey", "goldenrod"), pch=20, xpd=NA,bty='n', cex=1.2)
# text(x=-0.07, y=length(mylevels)+1.5, labels = "H1.H2.H3", xpd=NA, cex = 1)
#dev.off()

par(xpd=NA)
lwd <- 2
buf<-0.03
m<-1/10
H1="H1"
H2="H2"
H3="H3"
out="Cat"

y0 <- length(mylevels) + 1.5
y1 <- length(mylevels) + 4.5

s <- 0.03

midx <- 0.03

lines(c(midx,midx-s*0.5), c(y0,y1), lwd=lwd)
lines(c(midx,midx+s*0.5), c(y0,y1), lwd=lwd)

lines(c(midx-s*0.25,midx),c(y0+1.5,y1),lwd=lwd)
lines(c(midx-s*0.375,midx-s*0.25),c(y0+2.25,y1),lwd=lwd)

text(labels=c(H1,H2,H3,out),y=y1+0.4,x=c(midx-s*0.5, midx-s*0.25, midx,midx+s*0.5),xpd=NA)

# draw arrows
y <- y0 + 2.75

arrows(x0= 0.028, y0=y, x1= 0.022 , y1=y, col='darkred', length=0.1,lwd=2)

midx <- -0.03


lines(c(midx,midx-s*0.5), c(y0,y1), lwd=lwd)
lines(c(midx,midx+s*0.5), c(y0,y1), lwd=lwd)


lines(c(midx-s*0.25,midx),c(y0+1.5,y1),lwd=lwd)
lines(c(midx-s*0.375,midx-s*0.25),c(y0+2.25,y1),lwd=lwd)

arrows(x0= -0.032, y0=y, x1= -0.043 , y1=y, col='darkred', length=0.1,lwd=2)
#arrows(x0= -0.032, y0=y, x1= -0.038 , y1=y, col='darkred', length=0.1,lwd=2)

text(labels=c(H1,H2,H3,out),y=y1+0.4,x=c(midx-s*0.5, midx-s*0.25, midx,midx+s*0.5),xpd=NA)

dev.off()
