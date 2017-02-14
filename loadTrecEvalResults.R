loadTrecEvalResults<-function(trecEvalResultsFolder){
require("dplyr")
files <- list.files(path=trecEvalResultsFolder, pattern="*.txt", full.names=T, recursive=FALSE)
    result<-list()
    for(i in seq_along(1:length(files))){
      tmp<-read_delim(files[i], 
                 "\t", escape_double = FALSE, col_names = FALSE, 
                 col_types = cols( X2 = col_character(), X3 = col_double()), 
                 trim_ws = TRUE)
      runTag<-rep(paste("Core_",i,sep=""),nrow(tmp))
      tmp$runTag<-runTag
      result[[i]]<-tmp
      }
    completeTrecResult<-bind_rows(result)
  return(completeTrecResult)
}

