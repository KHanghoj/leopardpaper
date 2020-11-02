png("popStructure4panels3_2.png", units="in", width=10, height=10,res=300)
par(mfrow=c(2,2))
source("plotPCA.R")
source("plotNGSadmix.R")
source("plotTree.R")
source("plotEvalAdmix.R")

text(labels=c("a.","c.", "b.", "d."),x=c(-1.5, -1.5,-0.15, -0.15),y=c(2.5, 1.15, 2.5, 1.15), xpd=NA,cex=2)

dev.off()

