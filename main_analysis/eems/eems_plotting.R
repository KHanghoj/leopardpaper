if (dir.exists("rEEMSplots")){
    install.packages("rEEMSplots", repos = NULL, type = "source")
} else {
        stop("Move to the directory that contains the rEEMSplots source to install the package.")
    }

library(rEEMSplots)
require(grDevices)
require(graphics)
require(rgeos)
require(Rcpp)
require(RcppEigen)
require(raster)
library("rgdal")
library("rworldmap")
library("rworldxtra")
require(reemsplots2) 
require(ggplot2)

tiles2contours_standardize <- function(tiles, rates, seeds, marks, distm) {
    .Call('_rEEMSplots_tiles2contours_standardize', PACKAGE = 'rEEMSplots', tiles, rates, seeds, marks, distm)
}

tiles2contours <- function(tiles, rates, seeds, marks, distm) {
    .Call('_rEEMSplots_tiles2contours', PACKAGE = 'rEEMSplots', tiles, rates, seeds, marks, distm)
}

## upload polygon of the rainforest
rainforest <- read.table("rainforest.txt")


##### Generate plots

## leopard
eems_results <- file.path("eems/leopard/subSahara")
name_figures <- file.path("eems/leopard/subSahara/leopard_subSahara")

coord <- read.table(paste0("eems/leopard/subSahara/39_no1stDegree.coord"))

leopardPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                            add_outline = FALSE, add_demes = TRUE, 
                            col_outline = gray, dpi = 300, 
                            add_grid = FALSE, prob_level = 0.9, m_colscale = c(-2.5, 2.5))

leopardPlot2 <- leopardPlot$mrates01  

leopardPlot3 <- leopardPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                color = "#888888", size = 0.1) + coord_quickmap()

leopardPlot4 <- leopardPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

plotpath <- file.path(path.expand("eems/leopard/subSahara/"), "EEMS_leopard")
ggsave(paste0(plotpath, "-mrates01.png"), leopardPlot4, dpi = 1200,width = 6, height = 4)


## LION
eems_results <- file.path("eems/lion_new/subSahara/")
name_figures <- file.path("eems/lion_new/subSahara/lion_subSahara")
coord <- read.table(paste0("eems/lion_new/subSahara/datapath.coord"))

lionPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                               add_outline = FALSE, add_demes = TRUE, 
                               col_outline = gray, dpi = 300, 
                               add_grid = FALSE, prob_level = 0.9, m_colscale = c(-1.5, 1.5))

lionPlot2 <- lionPlot$mrates01  
lionPlot3 <- lionPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                         color = "#888888", size = 0.1) + coord_quickmap()
lionPlot4 <- lionPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

plotpath <- file.path(path.expand("eems/lion_new/subSahara"), "EEMS_lion")
ggsave(paste0(plotpath, "-mrates01.png"), lionPlot4, dpi = 1200,width = 6, height = 4)


## ELEPHANT
eems_results <- file.path("eems/elephant_savannah/subSahara/")
name_figures <- file.path("eems/elephant_savannah//subSahara/elephant_subSahara")
coord <- read.table(paste0("eems/elephant_savannah/subSahara/datapath.coord"))

elephantPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                            add_outline = FALSE, add_demes = TRUE, 
                            col_outline = gray, dpi = 300, 
                            add_grid = FALSE, prob_level = 0.9, m_colscale = c(-1.5, 1.5))

elephantPlot2 <- elephantPlot$mrates01  
elephantPlot3 <- elephantPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                   color = "#888888", size = 0.1) + coord_quickmap()
elephantPlot4 <- elephantPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2)

plotpath <- file.path(path.expand("eems/elephant_savannah//subSahara"), "EEMS_elephant")
ggsave(paste0(plotpath, "-mrates01.png"), elephantPlot4, dpi = 1200,width = 6, height = 4)


## WATERBUCK
eems_results <- file.path("eems/waterbuck/")
name_figures <- file.path("eems/waterbuck/waterbuck_subSahara")

coord <- read.table(paste0("eems/waterbuck/waterbuck4.coord"))

waterbuckPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                               add_outline = FALSE, add_demes = TRUE, 
                               col_outline = gray, dpi = 300, 
                               add_grid = FALSE, prob_level = 0.9, m_colscale = c(-2.5, 2.5))

waterbuckPlot2 <- waterbuckPlot$mrates01  

waterbuckPlot3 <- waterbuckPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                         color = "#888888", size = 0.1) + coord_quickmap()

waterbuckPlot4 <- waterbuckPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

plotpath <- file.path(path.expand("eems/waterbuck/subSahara"), "EEMS_waterbuck")
ggsave(paste0(plotpath, "-mrates01.png"), waterbuckPlot4, dpi = 1200,width = 6, height = 4)


## BUFFALO
eems_results <- file.path("eems/buffalo/")
name_figures <- file.path("eems/buffalo/buffalo_subSahara")

coord <- read.table(paste0("eems/buffalo/buffalo1.coord"))

buffaloPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                                 add_outline = FALSE, add_demes = TRUE, 
                                 col_outline = gray, dpi = 300, 
                                 add_grid = FALSE, prob_level = 0.9, m_colscale = c(-2.5, 2.5))

buffaloPlot2 <- buffaloPlot$mrates01  

buffaloPlot3 <- buffaloPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                             color = "#888888", size = 0.1) + coord_quickmap()

buffaloPlot4 <- buffaloPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

plotpath <- file.path(path.expand("eems/buffalo/subSahara"), "EEMS_buffalo")
ggsave(paste0(plotpath, "-mrates01.png"), buffaloPlot4, dpi = 1200,width = 6, height = 4)


## WARTHOG
eems_results <- file.path("eems/warthog/")
name_figures <- file.path("eems/warthog/warthog_subSahara")

coord <- read.table(paste0("eems/warthog/noDesZam.coord"))

warthogPlot <- make_eems_plots(mcmcpath = eems_results, longlat = FALSE, 
                               add_outline = FALSE, add_demes = TRUE, 
                               col_outline = gray, dpi = 300, 
                               add_grid = FALSE, prob_level = 0.9, m_colscale = c(-2.5, 2.5))

warthogPlot2 <- warthogPlot$mrates01  

warthogPlot3 <- warthogPlot2 + geom_path(data = map, aes(x = long, y = lat, group = group),
                                         color = "#888888", size = 0.1) + coord_quickmap()

warthogPlot4 <- warthogPlot3 + geom_polygon(data = rainforest, aes(x = V1, y = V2), fill = "gray60", alpha = 0.2) 

plotpath <- file.path(path.expand("eems/warthog/"), "EEMS_warthog")
ggsave(paste0(plotpath, "-mrates01.png"), warthogPlot4, dpi = 1200,width = 6, height = 4)



############# older script bits

map <- rworldmap::getMap(resolution = "high")
map <- broom::tidy(map)


### only Africa shapefile

map_world <- getMap()
map_africa <- map_world[which(map_world@data$continent == "Africa"), ]

eems.plots(mcmcpath = eems_results,
           plotpath = paste0(name_figures, "-shapefile"),
           longlat = FALSE, out.png = FALSE, add.demes = TRUE, lwd.map = 1,
           m.plot.xy = { plot(map_africa, col = NA, add = TRUE) },
           q.plot.xy = { plot(map_africa, col = NA, add = TRUE) })

### non-ggplot solution
projection_none <- "+proj=longlat +datum=WGS84"
projection_mercator <- "+proj=merc +datum=WGS8"
map_africa <- spTransform(map_africa, CRS(projection_mercator))

eems_results <- file.path("eems/elephants/wholeAfrica/")
name_figures <- file.path("eems/elephants/wholeAfrica/elephant_eems")

coord <- read.table(paste0("eems/elephants/datapath.coord"))
coords_merc <- sp::spTransform(SpatialPoints(coord, CRS(projection_none)), 
                               CRS(projection_mercator))

eems.plots(mcmcpath =  eems_results,
           plotpath = paste0(name_figures, "-labels-projected"),
           longlat = FALSE, out.png = FALSE, add.map = TRUE, lwd.map = 1, 
           xpd = TRUE, add.demes = TRUE,
           col.map = "gray40", col.grid = "gray80",
           projection.in = projection_none,
           projection.out = projection_mercator)

