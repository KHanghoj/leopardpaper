###
#Just based on Casia's markdown 
###


raw<-read.table("/home/leopard/users/jonas/redo/redoPCAngsd_e3.cov")
ev <- eigen(raw)
dat<-as.data.frame(ev$vectors)
master<-read.table("/home/casia16/leopard/Leopard samples master - Ark1.tsv",sep="\t",header=T)
list49<-read.table("/home/casia16/leopard/list49")
dupList=read.table("/home/casia16/leopard/newFilter.txt", sep=" ")

list39<-read.table("/home/casia16/leopard/list39.txt")
colnames(list49)="Serial_number"
colnames(list39)="Serial_number"
mergedMasterD=merge(list39, master, by.x=T)
rownames(dat)=as.character(mergedMasterD[,1])

dat2=cbind(dat,country=mergedMasterD$Country,aggregatedlocalityGroup=mergedMasterD$RH.aggregated.locality,
levels=c("Ghana", "Uganda", "TanzaniaN", "TanzaniaW", "TanzaniaE", "Zambia","Namibia")
dat2$aggregatedlocalityGroup <- factor(dat2$aggregatedlocalityGroup, levels=levels)

sum_var=sum(ev$values)
varPc1=format(round(ev$values[1]/sum_var*100, 2), nsmall = 2)
varPc2=format(round(ev$values[2]/sum_var*100, 2), nsmall = 2)
varPc3=format(round(ev$values[3]/sum_var*100, 2), nsmall = 2)
varPc4=format(round(ev$values[4]/sum_var*100, 2), nsmall = 2)

colvec <- 1:39
colvec[dat2$aggregatedlocalityGroup == "TanzaniaN"] <- "#B4C52B"
colvec[dat2$aggregatedlocalityGroup == "TanzaniaE"] <- "#009E35"
colvec[dat2$aggregatedlocalityGroup == "TanzaniaW"] <- "#1CCBA7"
colvec[dat2$aggregatedlocalityGroup == "Zambia"] <- "#1F9EE4"
colvec[dat2$aggregatedlocalityGroup == "Ghana"] <- "#EF4185"
colvec[dat2$aggregatedlocalityGroup == "Namibia"] <- "#E4950F"
colvec[dat2$aggregatedlocalityGroup == "Uganda"] <- "#FF00FF"


# Plotting and saving figure
png("pcaSupplementary.png", height=7, width=8, units="in", res=300)
pairs(dat2[,1:4], col=colvec, labels=c(paste0("PC1\n", varPc1, "%"), paste0("PC2\n", varPc2, "%"), paste0("PC3\n", varPc3, "%"), paste0("PC4\n", varPc4, "%")), pch=19, upper.panel=NULL)
legend("topright", bty='n', xpd=NA, c("TanzaniaN", "TanzaniaE", "TanzaniaW", "Zambia", "Ghana", "Namibia", "Uganda"), pch=19, col=c("#B4C52B", "#009E35", "#1CCBA7", "#1F9EE4", "#EF4185", "#E4950F", "#FF00FF"))
dev.off()
