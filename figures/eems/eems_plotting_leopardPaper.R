if (dir.exists("rEEMSplots")){
    install.packages("rEEMSplots", repos = NULL, type = "source")
} else {
        stop("Move to the directory that contains the rEEMSplots source to install the package.")
    }

require(reemsplots2) 
require(ggplot2)

tiles2contours_standardize <- function(tiles, rates, seeds, marks, distm) {
    .Call('_rEEMSplots_tiles2contours_standardize', PACKAGE = 'rEEMSplots', tiles, rates, seeds, marks, distm)
}

tiles2contours <- function(tiles, rates, seeds, marks, distm) {
    .Call('_rEEMSplots_tiles2contours', PACKAGE = 'rEEMSplots', tiles, rates, seeds, marks, distm)
}

## load map
map <- rworldmap::getMap(resolution = "high")
map <- broom::tidy(map)

## specity paths to input and output
eems_results <- file.path("leopard/subSahara/allsites/")
name_figures <- file.path("leopard/subSahara/allsites/leopard_subSahara")
plotpath <- file.path(path.expand("leopard/subSahara/allsites/"), "EEMS_leopard")

coord <- read.table(paste0("leopard/subSahara/allsites/39_no1stDegree.coord"))

## generate the plots
leopardPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                            add_outline = FALSE, add_demes = TRUE, 
                            col_outline = gray, dpi = 300, 
                            add_grid = FALSE, prob_level = 0.9, m_colscale = c(-2.5, 2.5))

## output the m1 plot
leopardPlot2 <- leopardPlot$mrates01
leopardPlot3 <- leopardPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                         color = "#888888", size = 0.1) +
    coord_quickmap()

leopardPlot4 <- leopardPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

## output the rdist3 plot
leopardPlot2b <- leopardPlot$rdist03  

## save
ggsave(paste0(plotpath, "-mrates01.png"), leopardPlot4, dpi = 1200,width = 6, height = 4)
ggsave(paste0(plotpath, "-rdist03.png"), leopardPlot2b, dpi = 600,width = 6, height = 5)
