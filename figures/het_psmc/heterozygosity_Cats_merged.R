## load modules
require(ggplot2)

## calculate heterozygosity
het <- read.table("all_est.ml", sep = "", header=FALSE)
hetEst <- as.data.frame(het[,3]/rowSums(het[,2:4]))
hetNames <- as.data.frame(het[,1])
hetComb <- cbind(hetNames, hetEst)
colnames(hetComb) <- c("Sample","Heterozygosity")
write.table(hetComb, file = "het_estimates.txt")

## Merge the values with information on sample locations, previously published het estimatee, and error rates
hetAll <- read.csv("heterozygosityTable.txt", sep = "\t", header = TRUE)

hetAll$Species <- factor(hetAll$Species, 
          levels = c("Leopard Cat","Cheetah","Puma","Eurasian Lynx", "Iberian Lynx", "Amur Tiger", "White Tiger", "Bengal Tiger", "Malayan Tiger", "Snow Leopard","Jaguar","African Lion", "White Lion", "Asiatic Lion", "Amur Leopard", "African Leopard"))

## color palette

leopardAllCatCol <- c("African Lion" = "#777777", "White Lion" = "#777777", "Asiatic Lion" = "#777777",
                      "Amur Tiger" = "#777777", "White Tiger" = "#777777",
                      "Bengal Tiger" = "#777777","Malayan Tiger" = "#777777",
                      "Snow Leopard" = "#777777", "Cheetah" = "#777777", "Amur Leopard" = "purple",
                      "Leopard Cat" = "#777777", "Jaguar" = "#777777",
                      "Puma" = "#777777", "Eurasian Lynx" = "#777777", "Iberian Lynx" = "#777777", "African Leopard" = "#f65d49")

## plot
hetBoxPlot <- ggplot(hetAll,aes(x = Species, y=as.numeric(Heterozygosity))) + 
  geom_boxplot(aes(colour = hetAll$Species), lwd = 1, outlier.shape = NA) + ylab("Heterozygosity") +
  #  labs(title = "Heterozygosity", vjust = 1) + 
  geom_point(aes(x = Species, colour = Species), position = position_jitter(width = 0.2)) +
  theme_classic() + geom_vline(xintercept = 17) +
  theme(axis.text.x = element_text(size = rel(2.3), colour = "grey20", angle = 45, vjust = 1, hjust = 1), 
        axis.text.y = element_text(colour = "black", size = rel(2.2)), 
        panel.background = element_rect(fill = "white", colour = "grey70"),
        axis.title.y  = element_text(size = rel(2.2), margin = margin(t = 0, r = 20, b = 0, l = 0)), axis.title.x = element_blank(),
        plot.title = element_text(size = rel(3), face = "bold"), panel.grid.major.y = element_line(colour = "grey90"),
        plot.margin = unit(c(1,1,1.5,1.2),"cm"), legend.position = "none",
        legend.title = element_text(size = rel(2.5)), legend.text = element_text(size = rel(2))) +
  scale_y_continuous(limits = c(0.000,0.0040), expand = c(0,0), breaks = seq(0,8,0.001)) +
  scale_color_manual(name = "Species/Population",breaks = levels(hetAll$Species), values = leopardAllCatCol, labels = levels(hetAll$Species))

png("het_withCats.png", width = 1920, height = 1080, units = "px", res = 72)
print(hetBoxPlot)
dev.off()
