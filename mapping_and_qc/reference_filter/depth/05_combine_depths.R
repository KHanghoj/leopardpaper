# Update data.table for fread on .gz files.
# install.packages('R.utils')
# install.packages('data.table')
require(R.utils)
require(data.table)

# Paths.
setwd('output/')
## alldepth.path <- 'all_perChr/'
lowdepth.path <- 'lowdepth_perChr/'
highdepth.path <- 'highdepth_perChr/'
combined.path <- 'combined_perChr/'
dir.create(combined.path)

# List of scaffolds.
scaffolds <- list.files(lowdepth.path, pattern = '*.pos.gz')

# Loop through scaffolds.
for (scaffold in sample(scaffolds)){
  combined.output <- paste(combined.path, scaffold, sep='')
  if(file.exists(combined.output)) next
  
  # print('Reading all samples')
  # combined <- fread(paste(alldepth.path, scaffold, sep = ''))[, 2:3]
  print('Reading lowdepth samples')
  combined <- fread(paste(lowdepth.path, scaffold, sep = ''))[, 2:3]
  ## combined <- merge(x = combined, by = 'pos', all.x=T,
  ##                   fread(paste(lowdepth.path, scaffold, sep = ''))[, 2:3])
  print('Reading highdepth samples')
  combined <- merge(x = combined, by = 'pos', all.x=T,
                    fread(paste(highdepth.path, scaffold, sep = ''))[, 2:3])
  ## colnames(combined) <- c('pos', 'allTotDepth', 'lowTotDepth', 'highTotDepth')
  colnames(combined) <- c('pos', 'lowTotDepth', 'highTotDepth')  
  print(paste('Writing to ', combined.output, sep = ''))
  write.table(combined, gzfile(paste(combined.path, scaffold, sep='')), quote = F, row.names = F, sep = '\t')
}
