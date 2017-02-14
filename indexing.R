createNewCore<-function(nameOfConfigSet,nameOfCore){
  nameOfConfigSet<-nameOfConfigSet
  nameOfCore<-nameOfCore
  path <- paste("~/solr-6.4.0/server/solr/",nameOfCore,"/conf",sep="")
  dir.create(path, recursive = TRUE)
  files <- list.files(paste("~/solr-6.4.0/server/solr/configsets/",nameOfConfigSet,"/conf/",sep=""),full.names = TRUE)
  file.copy(files, path, recursive = TRUE)
  out<-core_create(name = paste(nameOfCore,sep=""), instanceDir = paste(nameOfCore,sep=""), configSet = paste(nameOfConfigSet,sep=""))
return(out)
}


###### make multiple Indexes based on configsets in solr/configsets/conf 
##### Index Data into  _src_ field  with catchall field Text 
##### containing all other searchable text fields
makeMultipleIndexes<-function(numberOfIndexes,baseConffolder,baseCorename,docs){
  
  numberOfIndexes<-c(1:numberOfIndexes)
    result<-list()
    for(i in seq_along(numberOfIndexes)){
      indexname<-paste("Index_",i,sep="")    
      tmp<-list(paste(baseConffolder,"_",i,sep=""),paste(baseCorename,"_",i,sep=""),docs)
      result[[indexname]]<-tmp  
    }
    
    for(j in seq_along(result)){
      createNewCore(nameOfConfigSet = result[[j]][[1]],nameOfCore = result[[j]][[2]])
      solrium::add(x=result[[j]][[3]],name=result[[j]][[2]],raw=TRUE)
    }
print("Cores created and Files Indexed")    
}

reIndexMultipleIndexes<-function(numberOfIndexes,baseCorename,docs){
  numberOfIndexes<-c(1:numberOfIndexes)
  result<-list()
  for(i in seq_along(numberOfIndexes)){
    indexname<-paste("Index_",i,sep="")    
    tmp<-list(paste(baseCorename,"_",i,sep=""),docs)
    result[[indexname]]<-tmp  
  }
  for(j in seq_along(result)){
    solrium::add(x=result[[j]][[2]],name=result[[j]][[1]],raw=TRUE)
    print(paste("Core ", j ," indexed"),sep="")
    }
print("Indexing completed")  
}

deleteMultipleIndexes<-function(numberOfIndexes,baseCorename){
  numberOfIndexes<-c(1:numberOfIndexes)
  for(j in seq_along(numberOfIndexes)){
    solrium::delete_by_query("*:*",name=paste(baseCorename,"_",j,sep=""),raw=TRUE)
    print(paste("Core ", j ," deleted"),sep="")
  }
  print("Deletion completed")  
}