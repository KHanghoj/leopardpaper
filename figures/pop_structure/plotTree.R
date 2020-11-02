require(ape)

masterFile <- "https://docs.google.com/spreadsheets/d/1uDLUt1o1Z9CkIccmZ5LnJU9tsKvy2ZxtFa_ko9Q5AcA/edit?usp=sharing"
master <- gsheet::gsheet2tbl(masterFile)
master <- as.data.frame(master)
# inds <- master$Serial_number[master$Reason_to_exclude==""]
# locality <- master$RH_aggregated_locality[master$Reason_to_exclude==""]
inds <- master$Serial_number[is.na(master$Reason_to_exclude)]
locality <- master$RH_aggregated_locality[is.na(master$Reason_to_exclude)]

master2 <- data.frame(inds=inds, locality = locality)
master2  <- rbind(master2, data.frame(inds=c("3042211", "3042212"), locality=c("Asia", "Asia")))
print(master2)
rownames(master2) <- master2$inds
df = read.table("/home/leopard/users/krishang/ibs/ibs.ibsMat", h=F)
n = scan("/home/leopard/users/krishang/ibs/samplenames.txt")
# df = read.table("~/kelly/home/leopard/users/krishang/ibs/ibs.ibsMat", h=F)
# n = scan("~/kelly/home/leopard/users/krishang/ibs/samplenames.txt")
colnames(df) = n
rownames(df) = n

leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
"TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
"Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = "#FF00FF", "Asia" = "purple")


a = ape::fastme.bal(as.matrix(df))
master2 = master2[a$tip.label,]
newlabels = apply(master2 ,1 , paste, collapse="_")

# easy option to add asterisk
#newlabels= sub(pattern="5180_TanzaniaW", replacement="5180_TanzaniaW *", fixed=T, x=newlabels)
newlabels[newlabels=="5180_TanzaniaW"] = "5180_TanzaniaW_*"
newlabels[newlabels=="5520_TanzaniaN"] = "5520_TanzaniaN_*"
newlabels[newlabels=="7946_Namibia"] = "7946_Namibia_*"


a$tip.label = newlabels

## ape::plot.phylo(a,type='fan', use.edge.length=FALSE)

b = ape::root(a, outgroup=c("3042211_Asia", "3042212_Asia"), resolve.root=TRUE)
b$root.edge <- 1e-4 # nolint ape variable name
b <- rotate(b, 43)
## b$root.edge <- 1
## b$edge.length <- b$edge.length / b$edge.length[1] # nolint ape variable name


par(mar=c(0,1,1,0))
#ape::plot.phylo(b, type='phylo', use.edge.length=FALSE,
#                tip.color=leopardCol[as.character(master2[,2])],
#                root.edge=TRUE,
#                align.tip.label=FALSE)

#ape::plot.phylo(b, type='phylo', use.edge.length=TRUE,
 #               tip.color=leopardCol[as.character(master2[,2])],
  #              root.edge=TRUE,
   #             align.tip.label=FALSE,cex=1.2)

# more difficult option to add asterisk:manually. better control on size an dcolor
#text(labels="*", x=c(0.1,10,100)-0.5, y=c(0.1,5,100), cex=2,xpd=NA)

ape::plot.phylo(b, type='phylo', use.edge.length=TRUE,
                tip.color=leopardCol[as.character(master2[,2])],
                root.edge=TRUE,
                cex=1.18,
                no.margin=TRUE,
                align.tip.label=FALSE)
ape::add.scale.bar()
