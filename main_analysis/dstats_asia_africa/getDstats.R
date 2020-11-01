getDstat3pop <- function(dstatdf, poptree, exclude=NULL, locIdx = locIdx, method=1){
  #exclude should be vector with individual ids to exclude
  # extracts all individual dststs that meet poptree, where poptree is a vector c(H1,H2,H3)
  # if pop1 != pop2 returns also those that meet c(H2,H1,H3) with Dstat and Z score multiplied by -1 (IS THIS A CORRECT THING TO DO??)
  # return value is a dataframe with same columns as input plus poptree column specifying the population tree
  
  if(!is.null(exclude)) dstatdf <- dstatdf[!(dstatdf$H1%in%exclude|dstatdf$H2%in%exclude|dstatdf$H3%in%exclude),]
  
  if(poptree[1]==poptree[2]){
    if(method==1)
      indTrees <- matrix(as.character(as.matrix(dstatdf[,1:3])), ncol=3)
    else if(method==2)
      indTrees <- matrix(as.character(as.matrix(dstatdf[,9:11])), ncol=3)
    
    keep <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree))
    dstat <- dstatdf[keep,]
    cat("a")
  } else {
    if(method==1)
      indTrees <- matrix(as.character(as.matrix(dstatdf[,1:3])), ncol=3)
    else if(method==2)
      indTrees <- matrix(as.character(as.matrix(dstatdf[,9:11])), ncol=3)
    
    keep1 <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree))
    keep2 <- apply(matrix(locIdx[indTrees], ncol=3),  1, function(x) all(x == poptree[c(2,1,3)]))
    
    dstat <- dstatdf[keep1,]
    dstat2 <- dstatdf[keep2,]
    
    if(method==1){
      dstat2[,c("Dstat","jackEst", "Z")] <-  - dstat2[,c("Dstat","jackEst", "Z")]
      dstat2[,1:2] <- dstat2[,2:1]
    }else if(method==2){
      dstat2[,c("D","JK-D", "V(JK-D)","Z")] <-  - dstat2[,c("D","JK-D", "V(JK-D)","Z")]
      dstat2[,9:10] <- dstat2[,10:9]
  }
    dstat <- rbind(dstat,dstat2)
    cat("b")
  }
  
  dstat$poptree <- paste(poptree, collapse = ".")
  
  return(dstat)
}
