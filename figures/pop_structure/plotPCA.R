cor_mat <- read.table("/home/leopard/users/jonas/redo/redoPCAngsd_e3.cov")
ev <- eigen(cor_mat)
e <- ev$vectors

master<-read.table("/home/casia16/leopard/Leopard samples master - Ark1.tsv",sep="\t",header=T)

list39<-read.table("/home/casia16/leopard/list39.txt")
colnames(list39) <- "Serial_number"

df <- merge(list39, master, by.x=T)

leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
                "TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
                "Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = "#FF00FF")

pop <- as.vector(df$RH.aggregated.locality)
names(pop) <- as.character(df$Serial_number)

vars <- ev$values/sum(ev$values) * 100

plot(e[,1], e[,2], pch=21, cex=2, bg=leopardCol[pop],
     xlab=paste0("PC 1 (",round(vars[1], 2),"%)"), ylab=paste0("PC 2 (",round(vars[2], 2),"%)"),cex.lab=1.2)
legend(x=0.1, y=0.45,
       legend=names(leopardCol), pt.bg=leopardCol,
       pch=21,cex=1.3,bty='n')
