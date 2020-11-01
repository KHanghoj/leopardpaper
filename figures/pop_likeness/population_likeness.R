library(data.table)
library(grDevices)
library(scales)


masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
master <- gsheet::gsheet2tbl(masterFile)
df <- as.data.frame(master)


locIdx <- df$RH_aggregated_locality
names(locIdx) <- df$Serial_number

admixed <- c("7946", "5180", "5520","2523")
hiDep <- as.character(df$Serial_number[df$`Low_or_Hi_depth?`=="hi"])

dstatdf <- fread(cmd="cat /home/casia16/leopard/ABBABABA/results_redo15052020collapsedMapped/largesampleWholeRegionBlockSize5mb_notinkelly.txt | sed 's/.bam//g' ",data.table = F, stringsAsFactors = F)[,1:9]
#dstatdf <- fread(cmd="cat /home/leopard/users/genis/redo11052020collapsedMapped/Dstats_catoutgroup/tmp132blocksDstatsAllAfricanAsianCatMappedandCatH4.dstats.txt | sed 's/.bam//g' ",data.table = F, stringsAsFactors = F)[,1:9]


getDstat3pop <- function(dstatdf, poptree, exclude=NULL){ #exclude should be vector with individual ids to exclude
  # extracts all individual dststs that meet poptree, where poptree is a vector c(H1,H2,H3)
  # if pop1 != pop2 returns also those that meet c(H2,H1,H3) with Dstat and Z score multiplied by -1 (IS THIS A CORRECT THING TO DO??)
  # return value is a dataframe with same columns as input plus poptree column specifying the population tree
  
  if(!is.null(exclude)) dstatdf <- dstatdf[!(dstatdf$H1%in%exclude|dstatdf$H2%in%exclude|dstatdf$H3%in%exclude),]
  
  if(poptree[1]==poptree[2]){
    indTrees <- matrix(as.character(as.matrix(dstatdf[,1:3])), ncol=3)
    keep <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree))
    dstat <- dstatdf[keep,]
  } else {
    indTrees <- matrix(as.character(as.matrix(dstatdf[,1:3])), ncol=3)
    
    keep1 <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree))
    keep2 <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree[c(2,1,3)]))
    
    dstat1 <- dstatdf[keep1,]
    dstat2 <- dstatdf[keep2,]
    
    dstat2[,c("Dstat","jackEst", "Z")] <-  - dstat2[,c("Dstat","jackEst", "Z")]
    dstat2[,1:2] <- dstat2[,2:1]
    
    dstat <- rbind(dstat1,dstat2)
    
  }
  
  dstat$poptree <- paste(poptree, collapse = ".")
  
  return(dstat)
}

leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
                "TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
                "Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = "#FF00FF")
popord <- c("Ghana", "Uganda", "TanzaniaN", "TanzaniaW", "TanzaniaE", "Zambia", "Namibia")


### MAKE GROUP  H1 H2 FIX ZAMBIA CHANGE H3

groups <- matrix(c(rep("Zambia",2), "Ghana",
                   rep("Zambia",2), "Uganda",
                   rep("Zambia",2), "TanzaniaN",
                   rep("Zambia",2), "TanzaniaW",
                   rep("Zambia",2), "TanzaniaE",
                   rep("Zambia",2), "Namibia"),
                 ncol=3, byrow=T)


dstatFixH1H2ZambiaChangeH3 <- do.call(rbind,apply(groups, 1, getDstat3pop, dstatdf=dstatdf, exclude=c(admixed,hiDep)))
dstatFixH1H2ZambiaChangeH3$poptree <- factor(dstatFixH1H2ZambiaChangeH3$poptree, levels=apply(groups,1,paste, collapse="."))

leg_scale<-max(c(abs(min(dstatFixH1H2ZambiaChangeH3$Z)),abs(max(dstatFixH1H2ZambiaChangeH3$Z))))

#png("/home/leopard/users/cindy/dstats/",width=800, height = 800)
par(mar=c(5,18,4,4))
boxplot(dstatFixH1H2ZambiaChangeH3$Dstat ~ dstatFixH1H2ZambiaChangeH3$poptree,
        boxwex=0.5,
        main=expression(italic(D)*"-statistics with Zambia H1 and H2"),
        horizontal=T,las=2,ylim=c(-0.1,0.1),xlab=expression(italic(D)*"-statistics"),cex.axis=1.2,cex.lab=1.5,
        col=alpha(leopardCol[popord[6]], alpha=100),
        border=leopardCol[popord[6]])
dev.off()

#png("/home/leopard/users/cindy/dstats/",width=800, height = 800)
par(mar=c(5,18,4,4))
boxplot(dstatFixH1H2ZambiaChangeH3$Z ~ dstatFixH1H2ZambiaChangeH3$poptree,
        boxwex=0.5,
        main=expression(italic(Z)*"-score with Zambia H1 and H2"),
        horizontal=T,las=2,ylim=c(-leg_scale,leg_scale),xlab=expression(italic(Z)*"-score"),cex.axis=1.2,cex.lab=1.5,
        col=alpha(leopardCol[popord[6]], alpha=100),
        border=leopardCol[popord[6]])
abline(v=c(-3,3),lty=2)
dev.off()



### Same H1 and H2 groups, alternating African H3s 

group_ghana <- matrix(c(rep("Ghana",2), "Uganda",
                   rep("Ghana",2), "TanzaniaN",
                   rep("Ghana",2), "TanzaniaW",
                   rep("Ghana",2), "TanzaniaE",
                   rep("Ghana",2), "Zambia",
                   rep("Ghana",2), "Namibia"),
                 ncol=3, byrow=T)


#group_uganda <- matrix(c(rep("Uganda",2), "Ghana",
 #                  rep("Uganda",2), "TanzaniaN",
  #                 rep("Uganda",2), "TanzaniaW",
   #                rep("Uganda",2), "TanzaniaE",
    #               rep("Uganda",2), "Zambia",
     #              rep("Uganda",2), "Namibia"),
      #           ncol=3, byrow=T)


group_tanzn <- matrix(c(rep("TanzaniaN",2), "Ghana",
                         rep("TanzaniaN",2), "Uganda",
                         rep("TanzaniaN",2), "TanzaniaW",
                         rep("TanzaniaN",2), "TanzaniaE",
                         rep("TanzaniaN",2), "Zambia",
                         rep("TanzaniaN",2), "Namibia"),
                       ncol=3, byrow=T)

group_tanzw <- matrix(c(rep("TanzaniaW",2), "Ghana",
                        rep("TanzaniaW",2), "Uganda",
                        rep("TanzaniaW",2), "TanzaniaN",
                        rep("TanzaniaW",2), "TanzaniaE",
                        rep("TanzaniaW",2), "Zambia",
                        rep("TanzaniaW",2), "Namibia"),
                      ncol=3, byrow=T)

#group_tanze <- matrix(c(rep("TanzaniaE",2), "Ghana",
 #                       rep("TanzaniaE",2), "Uganda",
  #                      rep("TanzaniaE",2), "TanzaniaN",
   #                     rep("TanzaniaE",2), "TanzaniaW",
    #                    rep("TanzaniaE",2), "Zambia",
     #                   rep("TanzaniaE",2), "Namibia"),
      #                ncol=3, byrow=T)

group_zambia <- matrix(c(rep("Zambia",2), "Ghana",
                   rep("Zambia",2), "Uganda",
                   rep("Zambia",2), "TanzaniaN",
                   rep("Zambia",2), "TanzaniaW",
                   rep("Zambia",2), "TanzaniaE",
                   rep("Zambia",2), "Namibia"),
                 ncol=3, byrow=T)

group_namibia <- matrix(c(rep("Namibia",2), "Ghana",
                        rep("Namibia",2), "Uganda",
                        rep("Namibia",2), "TanzaniaN",
                        rep("Namibia",2), "TanzaniaW",
                        rep("Namibia",2), "Zambia",
                        rep("Namibia",2), "TanzaniaE"),
                      ncol=3, byrow=T)

groups<-ls(pattern = "group_")

# Produce PNGs for each plot
for (group in groups) {
    dstatFixH1H2ChangeH3=data.frame()
  group=get(group)
  dstatFixH1H2ChangeH3 <- do.call(rbind,apply(group, 1, getDstat3pop, dstatdf=dstatdf, exclude=c(admixed,hiDep)))
  dstatFixH1H2ChangeH3$poptree <- factor(dstatFixH1H2ChangeH3$poptree, levels=apply(group,1,paste, collapse="."))
  leg_scale=max(c(abs(min(dstatFixH1H2ZambiaChangeH3$Z)),abs(max(dstatFixH1H2ZambiaChangeH3$Z))))
  if (leg_scale > 3 ) leg_scale=leg_scale else leg_scale=4
  
  png(paste0("/home/leopard/users/cindy/dstats/poplike_alldep_",group[1],".png"),width=800, height = 800)
  par(mar=c(5,18,4,4))
  boxplot(dstatFixH1H2ChangeH3$Z ~ dstatFixH1H2ChangeH3$poptree,
          boxwex=0.5,
          main="",
          horizontal=T,las=2,ylim=c(-leg_scale,leg_scale),xlab=expression(italic(Z)*"-score"),cex.axis=1.2,cex.lab=1.5,
          #names=apply(as.matrix(strsplit(as.character(dstatFixH1H2ChangeH3$poptree),split = ".",fixed = TRUE)),1, paste, collapse=", "),
          col=alpha(leopardCol[group[1]], alpha=50),
          border=leopardCol[group[1]])
  abline(v=c(-3,3),lty=2)
  dev.off()
}



# Produce single plot with 5 panels
#png("/home/leopard/users/cindy/dstats/poplike_all_multipanel3.png",width=400, height = 800)
pdf("/home/leopard/users/cindy/dstats/poplike_all_multipanel3.pdf",width=6, height = 11)
layout(mat=matrix(c(1,4,5,3,2,0),nrow = 5, ncol=1))
for (group in groups) {
  dstatFixH1H2ChangeH3=data.frame()
  group=get(group)
  dstatFixH1H2ChangeH3 <- do.call(rbind,apply(group, 1, getDstat3pop, dstatdf=dstatdf, exclude=c(admixed,hiDep)))
  dstatFixH1H2ChangeH3$poptree <- factor(dstatFixH1H2ChangeH3$poptree, levels=apply(group,1,paste, collapse="."))
  lalala<-chartr('.', ',',dstatFixH1H2ChangeH3$poptree)
  lalala<-sapply(lalala, gsub, pattern = ",", replacement = ", ", fixed = TRUE)
  dstatFixH1H2ChangeH3<-cbind(dstatFixH1H2ChangeH3,lalala)
  #The last population name only
  hmmm=strsplit(as.character(dstatFixH1H2ChangeH3$poptree), split = ".",fixed = TRUE)
  hehehe<-data.frame()
  hehehe[1,1]<-"yay"
  for (i in 1:length(hmmm)) {
    blarb<-hmmm[[i]][3]
    hehehe<-rbind(hehehe,blarb)
  }
  ah=length(hmmm)+1
  hehehe<-as.data.frame(hehehe[2:ah,])
  names(hehehe)[1]<-"yay"
  dstatFixH1H2ChangeH3<-cbind(dstatFixH1H2ChangeH3,hehehe)
  
  leg_scale=max(c(abs(min(dstatFixH1H2ZambiaChangeH3$Z)),abs(max(dstatFixH1H2ZambiaChangeH3$Z))))
  if (leg_scale > 3 ) leg_scale=leg_scale else leg_scale=4
  
  
  par(mar=c(5,18,4,4))
  boxplot(dstatFixH1H2ChangeH3$Z ~ dstatFixH1H2ChangeH3$yay,
          boxwex=0.5,
          main=group[1],
          horizontal=T,las=2,ylim=c(-leg_scale,leg_scale),xlab=expression(italic(Z)*"-score"),cex.axis=1.2,cex.lab=1.5,
          #names=apply(as.matrix(strsplit(as.character(dstatFixH1H2ChangeH3$poptree),split = ".",fixed = TRUE)),1, paste, collapse=", "),
          col=alpha(leopardCol[group[1]], alpha=50),
          border=leopardCol[group[1]])
  abline(v=c(-3,3),lty=2)
}
dev.off()
