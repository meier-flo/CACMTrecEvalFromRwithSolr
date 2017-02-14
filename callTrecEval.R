callTrecEval<-function(pathToQrels,resultFolder,baseCorename,trecEvalResultFolder){ 
  numberOfFiles<-length(list.files(path=resultFolder,full.names=T, recursive=FALSE))
  numberOfIndexes<-c(1:numberOfFiles)
  dir.create(paste(trecEvalResultFolder,sep=""),showWarnings = FALSE)
  for(i in seq_along(numberOfIndexes)){
    system(paste("trec_eval -q ",pathToQrels," ",resultFolder,baseCorename,"_",i," > ",trecEvalResultFolder,"/trec_eval_result_",i,".txt",sep=""))
    }
  print("Writing")
}



