querySolrCoreCacmQueries<-function(coreName,queries){
#lets build a data.frame that has the structure of the TREC
#querynumber #Q0 constant #docID #rank #score #exp=runTag
    trecEvalResult<-data.frame(Qnum=integer(),Constant=character(),docID=integer(),Rank=integer(),Score=double(),RunTag=character(),stringsAsFactors = FALSE)
    for(i in 1:nrow(queries)){
    query.result<-solr_search(name=coreName,q=paste(queries[i,1],sep=""),fl=c('ID','score'),rows=100,parsetype="df")
    if(nrow(query.result)!=0){  
    colnames(query.result)[1]<-"docID"
      colnames(query.result)[2]<-"Score"
      Rank<-seq(nrow(query.result))
      Qnum<-rep(i,nrow(query.result))
      Constant<-rep("Q0",nrow(query.result))
      RunTag<-rep(paste(coreName),nrow(query.result))
      query.result$Rank<-Rank
      query.result$Qnum<-Qnum
      query.result$Constant<-Constant
      query.result$RunTag<-RunTag
      # richige Reihenfolge noch herstellen 
      columnOrder <- c("Qnum", "Constant","docID","Rank","Score","RunTag")
      query.result<-query.result[, c(columnOrder, setdiff(names(query.result),columnOrder))]
    trecEvalResult<-rbind(trecEvalResult,query.result)
    }else next
    }
    return(trecEvalResult)
}  
 
queryAndWriteResults<-function(numberOfIndexes,baseCorename,query.data){
  require("readr")
  numberOfIndexes<-c(1:numberOfIndexes)
  dir.create("results",showWarnings = FALSE)
  for(i in seq_along(numberOfIndexes)){
  search.result<-querySolrCoreCacmQueries(paste(baseCorename,"_",i,sep=""),query.data) 
  write_tsv(x = search.result,path = paste("results/cacm_core_",i,sep = ""),col_names = FALSE) 
  }
  print("Writing Result Files To Folder: results")
}  
  
#queryAndWriteResults(3,"cacm_core",test.queries)

#test.queries<-queries%>%slice(1:5) 
#testi<-solr_search(name = "cacm_core_1",q = "Pooch",fl=c('ID','score'),rows=100,parsetype="df") 
#testi<-querySolrCoreCacmQueries("cacm_core_2",test.queries)



