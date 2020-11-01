#library(data.table)
#library(RColorBrewer)
library(colorspace)
source("/home/genis/admix_evaluation/implementation_c/evaluateAdmix/visFuns.R")
#source("/home/genis/software/evalAdmix/visFuns.R")

q4 <- as.matrix(read.table("/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/results/4/admixResultLeopardBeagleReMappedV3.4.18.qopt_conv"))

masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
master <- gsheet::gsheet2tbl(masterFile)
df <- as.data.frame(master)


inds <- df$Serial_number[is.na(df$Reason_to_exclude)]
locality <- df$RH_aggregated_locality[is.na(df$Reason_to_exclude)]
country <- df$Country[is.na(df$Reason_to_exclude)]

inds2 <- inds[!inds %in% c(8647, 7943,8540)]
locality2 <- locality[!inds %in% c(8647, 7943,8540)]
country2 <- country[!inds %in% c(8647, 7943,8540)]

popord <- c("Ghana", "Namibia", "Zambia", "TanzaniaW", "TanzaniaE", "TanzaniaN", "Uganda")
ord <- orderInds(q4, pop = locality2, popord=popord)

refinds <- c(7934, 4343, 7246, 3241)
refidx <- sapply(refinds, function(x) which(inds2==x))

oldadmixCol <- c("#b81e22",  "#2B597D", "#984EA3", "#e0d152")
admixCol <- lighten(oldadmixCol, amount=0.3)

colord <- 1:4


q <-q4[,orderK(q4, refinds=refidx[1:4])]
colorpal<-admixCol[colord][1:4]
pop<-locality2

par(mar=c(4,4,4,2))

barplot(t(q)[,ord], col=colorpal, space=0, border=NA, cex.axis=1.1,cex.lab=1.3,
          ylab="Admixture proportions", xlab="",xpd=NA)
abline(v=1:nrow(q), col="white", lwd=0.2)
abline(v=cumsum(sapply(unique(pop[ord]),function(x){sum(pop[ord]==x)})),col=1,lwd=1.2)
text(labels="*", x=c(5, 24,32)-0.5, y=1.03, cex=2,xpd=NA)
