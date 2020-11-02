######## Plotting error rates estimated from ANGSD -doAncError

## load modules
require(ggplot2)
require(ggrepel)
require(tidyverse)

## Upload file with sample info and error rates
errorRates <- read.csv("leopardError.txt", 
                    sep = "\t", header = TRUE)

## Define levels
errorRates$Location <- factor(errorRates$Location, levels = c("TanzaniaN","TanzaniaE","TanzaniaW", "Zambia","Ghana","Namibia","Uganda"))
errorRates$Sample <- factor(errorRates$Sample, levels = errorRates$Sample[order(errorRates$Location)])

## Define color palette
leopardCol <- c("TanzaniaN" = "#B4C52B", "TanzaniaE" = "#009E35",
                "TanzaniaW" = "#1CCBA7", "Zambia" = "#1F9EE4",
                "Ghana" = "#EF4185","Namibia" = "#E4950F","Uganda" = "#FF00FF")

## Plot
errorRatesBP <- ggplot(errorRates, aes(x = as.character(errorRates$Sample), y = ErrorRate, fill = errorRates$Location)) + 
  geom_bar(stat = "identity", width = 0.6, aes(x = as.character(errorRates$Sample))) +
  labs(title = "Error Rate (%)", vjust = 1) + 
  theme(axis.text.x = element_text(size = rel(2), colour = "grey30", angle = 90, vjust = 0.2, hjust = 0.5), 
        axis.text.y = element_text(face="bold", colour = "black", size = rel(2)), 
        axis.title = element_blank(), panel.background = element_rect(fill = "white", colour = "grey50"),
        plot.title = element_text(size = rel(2), face = "bold"), panel.grid.major.y = element_line(colour = "grey50"),
        plot.margin = unit(c(1,1,1.5,1.2),"cm"),
        legend.title = element_text(size = rel(2)), legend.text = element_text(size = rel(1.7)), 
        legend.position="bottom", legend.direction = "horizontal", 
        legend.key.width = unit(2, "cm"), legend.spacing.x = unit(1.2, "cm")) +
  scale_y_continuous(limits = c(-0.5,8.5), expand = c(0,0), breaks = seq(-0.5,10,1)) +
  scale_fill_manual(name = "Locations", values = leopardCol, labels = levels(errorRates$Location), 
  guide = guide_legend(direction = "horizontal", ncol = 7, label.position = "bottom")) +
  geom_col(position = position_dodge2(width = 1, preserve = "single")) 

png("leopard_errorRate.png", width = 1920, height = 1080, units = "px", res = 72)
print(errorRatesBP)
dev.off()

###### Remove four outliers

errorRatesF <- errorRates[-c(23,25,34,35), ]

## Define levels
errorRatesF$Location <- factor(errorRatesF$Location, levels = c("TanzaniaN","TanzaniaE","TanzaniaW", "Zambia","Ghana","Namibia","Uganda"))
errorRatesF$Sample <- factor(errorRatesF$Sample, levels = errorRatesF$Sample[order(errorRatesF$Location)])

## Plot filtered
errorRatesFBP <- ggplot(errorRatesF, aes(x = as.character(Sample), y = ErrorRate, fill = Location)) + 
  geom_bar(stat = "identity", width = 0.6, aes(x = as.character(Sample))) +
  labs(title = "Error Rate (%)", vjust = 1) + 
  theme(axis.text.x = element_text(size = rel(2), colour = "grey30", angle = 90, vjust = 0.2, hjust = 0.5), 
        axis.text.y = element_text(face="bold", colour = "black", size = rel(2)), 
        axis.title = element_blank(), panel.background = element_rect(fill = "white", colour = "grey50"),
        plot.title = element_text(size = rel(2), face = "bold"), panel.grid.major.y = element_line(colour = "grey50"),
        panel.grid.minor.y = element_line(colour = "grey50"), plot.margin = unit(c(1,1,1.5,1.2),"cm"),
        legend.title = element_text(size = rel(2)), legend.text = element_text(size = rel(1.7)), 
        legend.position="bottom", legend.direction = "horizontal", 
        legend.key.width = unit(2, "cm"), legend.spacing.x = unit(1.2, "cm")) +
  scale_y_continuous(limits = c(0,0.11), expand = c(0,0), minor_breaks = seq(0,8,0.01), breaks = seq(0,8,0.05)) +
  scale_fill_manual(name = "Locations", values = leopardCol, labels = levels(errorRatesF$Location), 
                    guide = guide_legend(direction = "horizontal", ncol = 7, label.position = "bottom")) +
  geom_col(position = position_dodge2(width = 1, preserve = "single")) 

png("leopard_errorRate_filtered.png", width = 1920, height = 1080, units = "px", res = 72)
print(errorRatesFBP)
dev.off()

## Plot error rates vs heterozygosity
## plot all samples

het_error_plot <- ggplot(errorRates, aes(x = ErrorRate, y=as.numeric(Heterozygosity), 
                                           color = errorRates$Location)) + geom_point(aes(x = ErrorRate), size = 6) + 
  scale_color_manual(name = "Populations", values = leopardCol, labels = levels(errorRates$Location)) + 
  xlab("Error Rate") + ylab("Heterozygosity") + labs(title = "Error Rate vs Heterozygosity", vjust = 1) + 
  theme(axis.text = element_text(size = rel(1.5)),
        axis.title = element_text(size = rel(2), vjust = -1),
        plot.title = element_text(size = rel(2),face="bold", colour = "black"), plot.margin = unit(c(1,1,1.5,1.2),"cm"),
        legend.title = element_text(size = rel(1.5)), legend.text = element_text(size = 16)) + 
  geom_text_repel(label = errorRates$Sample, size = 6, point.padding = 1)

png("leopard_errorRate_vs_het.png", width = 1920, height = 1080, units = "px", res = 72)
print(het_error_plot)
dev.off()

## plot filtered

het_error_plotF <- ggplot(errorRatesF, aes(x = ErrorRate, y=as.numeric(Heterozygosity),
                                           color = errorRatesF$Location)) + geom_point(aes(x = ErrorRate), size = 6) +
  scale_color_manual(name = "Populations", values = leopardCol, labels = levels(errorRatesF$Location)) +
  xlab("Error Rate") + ylab("Heterozygosity") + labs(title = "Error Rate vs Heterozygosity", vjust = 1) +
  theme(axis.text = element_text(size = rel(1.5)),
        axis.title = element_text(size = rel(2), vjust = -1),
        plot.title = element_text(size = rel(2),face="bold", colour = "black"), plot.margin = unit(c(1,1,1.5,1.2),"cm"),
        legend.title = element_text(size = rel(1.5)), legend.text = element_text(size = 16)) +
  geom_text_repel(label = errorRatesF$Sample, size = 6, point.padding = 1)

png("leopard_errorRate_filtered_vs_het.png", width = 1920, height = 1080, units = "px", res = 72)
print(het_error_plotF)
dev.off()

