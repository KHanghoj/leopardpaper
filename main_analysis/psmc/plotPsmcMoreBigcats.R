# read pscm output psmc.result() adapted from function in https://datadryad.org/stash/dataset/doi:10.5061/dryad.0618v


##-------Rescale the ith iteration result of PSMC, and make ready for plotting
# file: result file from PSMC
# i.iteration: the ith iteration
# mu: mutation rate
# s: bin size
# g: years per generation


psmc.result<-function(file,i.iteration=25,mu=1e-8,s=100,g=1)
{
	X<-scan(file=file,what="",sep="\n",quiet=TRUE)
	
	START<-grep("^RD",X)
	END<-grep("^//",X)
	
	X<-X[START[i.iteration+1]:END[i.iteration+1]]
	
	TR<-grep("^TR",X,value=TRUE)
	RS<-grep("^RS",X,value=TRUE)
	
	write(TR,"temp.psmc.result")
	theta0<-as.numeric(read.table("temp.psmc.result")[1,2])
	N0<-theta0/4/mu/s 
	
	write(RS,"temp.psmc.result")
	a<-read.table("temp.psmc.result")
	Generation<-as.numeric(2*N0*a[,3]) # a[,3] is t_k
	Ne<-as.numeric(N0*a[,4]) #a[,4] is lambda_k
	
	file.remove("temp.psmc.result")
	
	n.points<-length(Ne)
	YearsAgo<-c(as.numeric(rbind(Generation[-n.points],Generation[-1])),
		Generation[n.points])*g
	Ne<-c(as.numeric(rbind(Ne[-n.points],Ne[-n.points])),
		Ne[n.points])
	
	data.frame(YearsAgo,Ne)
}


files <-list.files("/home/leopard/users/krishang/psmcBigcats/results/psmc_output/baserepeat/3",".psmc",full.names=T)

mu <- 1e-8
g <- 7.5

res <- lapply(files, psmc.result,mu=mu,g=g)
names(res) <- gsub(".psmc", "",basename(files))

exclude <- c("BR406", "CYP47")
res <- res[!names(res) %in% exclude]

#masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
#master <- gsheet::gsheet2tbl(masterFile)
#df <- as.data.frame(master)

inds <- names(res)
sps <- c(rep("Amur leopard",2),
         rep("African leopard",5),
         "Tiger", "Lion", "Jaguar", "Snow leopard", "Tiger")


names(sps) <- inds

cols <- RColorBrewer::brewer.pal("Set1", n=8)[c(1:5,8)]
names(cols) <- unique(sps)
#leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
#                "TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
#                "Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = #"#FF00FF",
#                "Asia" = "purple")




res2 <- lapply(res, function(x) x[-((nrow(x)-8):nrow(x)),])


rm_last <- function(x){

    nes <- unique(x$Ne)
    rmv <- nes[(length(nes)-1):length(nes)]
    x[!x$Ne%in%rmv,]
}

res2 <- lapply(res2,rm_last)

bitmap("/home/leopard/users/genis/redo11052020collapsedMapped/plot_psmc/psmc_plot_moreCats_75gen.png",width=12,height=6,res=300)
ymax <- max(sapply(res2,function(x)max(x$Ne)))
ymax <- 8e4
#png("/home/leopard/users/genis/redo11052020collapsedMapped/plot_psmc/psmc_plot75gen.png",width=1200, height=600)
par(mar=c(5,5,4,15)+0.1)
plot(type='l', x=res2[[inds[1]]]$YearsAgo, log='x', y=res2[[inds[1]]]$Ne, col = cols[sps[inds[1]]],lwd=3,
     xlab="Years ago (mu=1e-8, g=7.5)",
     ylab="Effective population size",cex.lab=1.5, xaxt='n',
     xlim=c(1.5 * 10^4, 1.5 * 10^6), ylim=c(0, ymax), cex.axis=1.5)
#xpos <- seq(1.5 * 10^4, 1.5 * 10^6,by=10000)
xpos <- c(1.5e4, 5e4, 1e5, 2e5, 4e5, 6e5,1e6, 1.5e6)
xpos <- c(seq(1e4,1e5,by=1e4), seq(1e5, 1e6, by=1e5))
xlabs <- c(2e4, 1e5, 5e5,1e6)
axis(1, at=xpos, labels=F)
axis(1, at=xlabs, tick=F, labels= paste(as.integer(xlabs/1e3), "kya"), cex.axis=1.5)

for(i in 2:12) lines(x=res2[[inds[i]]]$YearsAgo, y=res2[[inds[i]]]$Ne,  col = cols[sps[inds[i]]],lwd=3)
legend(legend=c("African leopard", "Amur leopard","Lion", "Jaguar", "Tiger", "Snow leopard"),
       col=cols[c("African leopard", "Amur leopard","Lion", "Jaguar", "Tiger", "Snow leopard")],
       x=20e5, y=6e4,
       lty=1,lwd=3,,border=NA, bty="n",cex=1.5, xpd=NA)
dev.off()




#################################################
########3 DO SAME WITH 5 GENRATION TIME #########
#################################################

mu <- 1e-8
g <- 5


res <- lapply(files, psmc.result,mu=mu,g=g)
names(res) <- gsub(".psmc", "",basename(files))

exclude <- c("BR406", "CYP47")
res <- res[!names(res) %in% exclude]

#masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
#master <- gsheet::gsheet2tbl(masterFile)
#df <- as.data.frame(master)

inds <- names(res)
sps <- c(rep("Amur leopard",2),
         rep("African leopard",5),
         "Tiger", "Lion", "Jaguar", "Snow leopard", "Tiger")


names(sps) <- inds

cols <- RColorBrewer::brewer.pal("Set1", n=8)[c(1:5,8)]
names(cols) <- unique(sps)
#leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
#                "TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
#                "Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = #"#FF00FF",
#                "Asia" = "purple")




res2 <- lapply(res, function(x) x[-((nrow(x)-8):nrow(x)),])


rm_last <- function(x){

    nes <- unique(x$Ne)
    rmv <- nes[(length(nes)-1):length(nes)]
    x[!x$Ne%in%rmv,]
}

res2 <- lapply(res2,rm_last)
bitmap("/home/leopard/users/genis/redo11052020collapsedMapped/plot_psmc/psmc_plot_moreCats_5gen.png",width=12,height=6,res=300)
ymax <- max(sapply(res2,function(x)max(x$Ne)))
ymax <- 8e4
#png("/home/leopard/users/genis/redo11052020collapsedMapped/plot_psmc/psmc_plot75gen.png",width=1200, height=600)
par(mar=c(5,5,4,15)+0.1)
plot(type='l', x=res2[[inds[1]]]$YearsAgo, log='x', y=res2[[inds[1]]]$Ne, col = cols[sps[inds[1]]],lwd=3,
     xlab="Years ago (mu=1e-8, g=5)",
     ylab="Effective population size",cex.lab=1.5, xaxt='n',
     xlim=c(1.5 * 10^4, 1.5 * 10^6), ylim=c(0, ymax), cex.axis=1.5)
#xpos <- seq(1.5 * 10^4, 1.5 * 10^6,by=10000)
xpos <- c(1.5e4, 5e4, 1e5, 2e5, 4e5, 6e5,1e6, 1.5e6)
xpos <- c(seq(1e4,1e5,by=1e4), seq(1e5, 1e6, by=1e5))
xlabs <- c(2e4, 1e5, 5e5,1e6)
axis(1, at=xpos, labels=F)
axis(1, at=xlabs, tick=F, labels= paste(as.integer(xlabs/1e3), "kya"), cex.axis=1.5)

for(i in 2:12) lines(x=res2[[inds[i]]]$YearsAgo, y=res2[[inds[i]]]$Ne,  col = cols[sps[inds[i]]],lwd=3)
legend(legend=c("African leopard", "Amur leopard","Lion", "Jaguar", "Tiger", "Snow leopard"),
       col=cols[c("African leopard", "Amur leopard","Lion", "Jaguar", "Tiger", "Snow leopard")],
       x=20e5, y=6e4,
       lty=1,lwd=3,,border=NA, bty="n",cex=1.5, xpd=NA)
dev.off()
