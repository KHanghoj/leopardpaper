
source("/home/genis/software/evalAdmix/visFuns.R")

masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
master <- gsheet::gsheet2tbl(masterFile)
df <- as.data.frame(master)


inds <- df$Serial_number[is.na(df$Reason_to_exclude)]
locality <- df$RH_aggregated_locality[is.na(df$Reason_to_exclude)]
country <- df$Country[is.na(df$Reason_to_exclude)]

inds2 <- inds[!inds %in% c(8647, 7943,8540)]
locality2 <- locality[!inds %in% c(8647, 7943,8540)]
country2 <- country[!inds %in% c(8647, 7943,8540)]

q4 <- as.matrix(read.table("/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/results/4/admixResultLeopardBeagleReMappedV3.4.18.qopt_conv"))


popord <- c("Ghana", "Namibia", "Zambia", "TanzaniaW", "TanzaniaE", "TanzaniaN", "Uganda")
ord <- orderInds(q4, pop = locality2, popord=popord)

refinds <- c(7934, 4343, 7246, 3241)
refidx <- sapply(refinds, function(x) which(inds2==x))

corresk4 <- as.matrix(read.table("/home/leopard/users/genis/redo11052020collapsedMapped/ngsadmix/results/evaladmix/evalNGSadmixLeopReMappedV3No2relNoUgK4.corres"))








cor_mat <- corresk4
pop=locality2
ord=ord
superpop=NULL
title=""
min_z=NA
max_z=0.1
cex.main=1.5
cex.lab=1.5
cex.legend=1.5
color_palette=c("#001260", "#EAEDE9", "#601200")
pop_labels = c(T,T)
plot_legend = T
adjlab = 0.1
rotatelabpop=0
rotatelabsuperpop=0
lineswidth=1
lineswidthsuperpop=2
adjlabsuperpop=0.16
cex.lab.2 = 1.5




par(mar=c(6.5,4.9,2.5,2.9))



N <- dim(cor_mat)[1]


if(is.null(ord)&!is.null(pop)) ord <- order(pop)
if(is.null(ord)&is.null(pop)) ord <- 1:nrow(cor_mat)

if(is.null(pop)){
    pop <- rep(" ", nrow(cor_mat))
    lineswidth <- 0
}

pop<-pop[ord]

N_pop <- vapply(unique(pop[ord]), function(x) sum(pop==x),1)

cor_mat <- cor_mat[ord,ord]

## Set lower part of matrix as population mean correlation
mean_cors <- matrix(ncol=length(unique(pop)), nrow=length(unique(pop)))
colnames(mean_cors) <- unique(pop)
rownames(mean_cors) <- unique(pop)

for(i1 in 1:(length(unique(pop)))){
    for(i2 in 1:(length(unique(pop)))){
        p1 <- unique(pop)[i1]
        p2 <- unique(pop)[i2]
        mean_cors[i1,i2]<- mean(cor_mat[which(pop==p1),
                                        which(pop==p2)][!is.na(cor_mat[which(pop==p1),
                                                                       which(pop==p2)])])
        
    }
}

for(i1 in 1:(N-1)){
    for(i2 in (i1+1):N){
        cor_mat[i1, i2] <- mean_cors[pop[i2], pop[i1]]
        
    }
}

z_lims <- c(min_z, max_z)

if(all(is.na(z_lims))) z_lims <- c(-max(abs(cor_mat[!is.na(cor_mat)])),
                                   max(abs(cor_mat[!is.na(cor_mat)])))
#if(all(is.null(z_lims))) max_z <- max(abs(cor_mat[!is.na(cor_mat)]))


if(any(is.na(z_lims))) z_lims <- c(-z_lims[!is.na(z_lims)], z_lims[!is.na(z_lims)])
#if(any(is.null(z_lims))) max_z <- z_lims[!is.null(z_lims)]

min_z <- z_lims[1]
max_z <- z_lims[2]

diag(cor_mat) <- 10
nHalf <- 10

# make sure col palette is centered on 0
Min <- min_z
Max <- max_z
Thresh <- 0

## Make vector of colors for values below threshold
rc1 <- colorRampPalette(colors = color_palette[1:2], space="Lab")(nHalf)    
## Make vector of colors for values above threshold
rc2 <- colorRampPalette(colors = color_palette[2:3], space="Lab")(nHalf)
rampcols <- c(rc1, rc2)

rampcols[c(nHalf, nHalf+1)] <- rgb(t(col2rgb(color_palette[2])), maxColorValue=256) 

rb1 <- seq(Min, Thresh, length.out=nHalf+1)
rb2 <- seq(Thresh, Max, length.out=nHalf+1)[-1]
rampbreaks <- c(rb1, rb2)
rlegend <- as.raster(matrix(rampcols, ncol=1))#[length(rampcols):1,])

image(t(cor_mat), col=rampcols, breaks=rampbreaks,
      yaxt="n",xaxt="n", zlim=c(min_z,max_z),useRaster=T,
      main=title, 
      oldstyle=T,cex.main=cex.main,xpd=NA)
image(ifelse(t(cor_mat>max_z),1,NA),col="darkred",add=T)
if(min(cor_mat)<min_z) image(ifelse(t(cor_mat<min_z),1,NA),col="darkslateblue",add=T)
image(ifelse(t(cor_mat==10),1,NA),col="black",add=T)

# lines delimiting pop
abline(v=grconvertX(cumsum(sapply(unique(pop),function(x){sum(pop==x)}))/N,"npc","user"),
       col=1,lwd=lineswidth,xpd=F)
abline(h=grconvertY(cumsum(sapply(unique(pop),function(x){sum(pop==x)}))/N, "npc", "user"),
       col=1,lwd=lineswidth,xpd=F)


# ADD LEGEND BELOW PLOT
text(labels="Correlation of residuals", x=0.5, y=-0.07, xpd=NA,cex=1.3)
rasterImage(t(rlegend), xleft=0, xright=1, ybottom=-0.2, ytop = -0.1, xpd=NA)
text(labels=c(min_z, 0, max_z), x=c(0, 0.5, 1), y=-0.25,cex=1.2,xpd=NA)


#rasterImage(rlegend, xleft=0.25, xright=0.5, ybottom=-0.9, ytop = -0.15, xpd=NA, angle=90, interpolate=T)
#rasterImage(rlegend, xleft=0.25, xright=0.75, ybottom=-0.3, ytop = -0.15, xpd=NA, horizontal=T)
# add pop labels above and left
text(x=sort(tapply(1:length(pop),pop,mean)/length(pop)),
     y=1.17,
     labels=unique(pop),xpd=NA,cex=1.2, srt=90)
text(x=-0.15,
     y=sort(tapply(1:length(pop),pop,mean)/length(pop)),
     labels=unique(pop),xpd=NA, cex=1.2,srt=0)
