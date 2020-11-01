datadir <- 'output/'
plotdir <- 'output/plots/'
## groups <- c('all', 'lowdepth', 'highdepth')
groups <- c('lowdepth', 'highdepth')

for (group in groups){
        # Read global depth distribution for each scaffold and sum.
	print(paste(datadir, group, '_perChr', sep=''))

        scaffolds <- list.files(paste(datadir, group, '_perChr', sep=''), pattern = '*.depthGlobal', full.names = T)
        n_scaffolds <- length(scaffolds)
	
        scaffolds.matrix <- matrix(nrow = n_scaffolds, ncol = 3001) # hardcoded max depth of 3000.
        for (n in 1:n_scaffolds) {
                scaffolds.matrix[n, ] <- as.matrix(read.table(scaffolds[n], col.names = F))[,1]
        }
        depth.global <- colSums(scaffolds.matrix)
        depth.global.cumsum <- cumsum(as.numeric(depth.global))
        scaffolds.matrix <- ''
        
        # Find thresholds.
        q99 <- depth.global.cumsum[length(depth.global.cumsum)]*0.99
        q01 <- depth.global.cumsum[length(depth.global.cumsum)]*0.01
        q99.threshold <- min(which(depth.global.cumsum > q99))
        q01.threshold <- min(which(depth.global.cumsum > q01))
        
        # Plot.
        # Full range.
        #png(paste(plotdir, group, '-fullrange.png', sep=''), width = 600, height = 300)
        pdf(paste(plotdir, group, '-fullrange.pdf', sep=''), width = 6, height = 3)
        par(mfrow=c(1,2))
        plot(depth.global, type='l',
             xlab = 'Global depth (count)', ylab = 'Number of sites')
        abline(v = q99.threshold, col='red', lty=2); abline(v = q01.threshold, col='red', lty=2)
        legend('topright', legend = c(paste('1% thres:', q01.threshold, sep=''),
                                      paste('99% thres: ', q99.threshold, sep='')),  bty = "n")
        plot(depth.global.cumsum, type='l',
             xlab = 'Global depth (count)', ylab = 'Cumulative number of sites')
        abline(v = q99.threshold, col='red', lty=2); abline(v = q01.threshold, col='red', lty=2)
        mtext(paste('Full range - ', group, sep=''), side = 3, line = -2, outer = TRUE)
        dev.off()
        
        # Zoomed in.
        x_max <- 600
        #png(paste(plotdir, group, '-zoomin.png', sep=''), width = 600, height = 300)
        pdf(paste(plotdir, group, '-zoomin.pdf', sep=''), width = 6, height = 3)
        par(mfrow=c(1,2))
        plot(depth.global, type='l', xlim=c(0, x_max),
             xlab = 'Global depth (count)', ylab = 'Number of sites')
        abline(v = q99.threshold, col='red', lty=2); abline(v = q01.threshold, col='red', lty=2)
        legend('topright', legend = c(paste('1% thres:', q01.threshold, sep=''),
                                      paste('99% thres: ', q99.threshold, sep='')),  bty = "n")
        plot(depth.global.cumsum, type='l', xlim=c(0, x_max),
             xlab = 'Global depth (count)', ylab = 'Cumulative number of sites')
        abline(v = q99.threshold, col='red', lty=2); abline(v = q01.threshold, col='red', lty=2)
        abline(h = q99, col='grey', lty=2); abline(h = q01, col='grey', lty=2)
        mtext(paste('Zoomed in - ', group, sep=''), side = 3, line = -2, outer = TRUE)
        dev.off()
}
