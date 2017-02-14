parseCacmAll<-function(cacmDocs){
  # RegexExpressions for having every doc in a single list position
  doc.xpr<-"(?<=\\.I).*?(?=\\.I\\s)"
  
  # Regexpression for parts of each doc like ID, author etc ...
  id.xpr<-"(?<=\\s).*?(?=\\.T\\s)"
  title.xpr<-"(?<=\\.T).*?(?=\\.[A-Z]\\s)"
  author.xpr<-"(?<=\\.A).*?(?=\\.[A-Z]\\s)"
  date.xpr<-"(?<=\\.B).*?(?=\\.[A-Z]\\s)"
  content.xpr<-"(?<=\\.W).*?(?=\\.[A-Z]\\s)"
  
    #cacmDocs is filepath to the files
    cacmtext<-paste(readLines(cacmDocs),collapse=" ")
    cacm.docs.list<-regmatches(cacmtext,gregexpr(doc.xpr,cacmtext,perl=TRUE)) 
    
    cacm.docs<-data.frame(ID=integer(),Title=character(),Author=character(),Date=integer(),Content=character(),stringsAsFactors = FALSE)
    #IDTRUE=integer(),
    for(i in seq_along(cacm.docs.list[[1]])){
        cacm.file<-data.frame(ID=i,
                              #IDTRUE=ifelse(identical(regmatches(cacm.docs.list[[1]][[i]],regexpr(id.xpr,cacm.docs.list[[1]][[i]],perl=TRUE)),character(0)),NA,regmatches(cacm.docs.list[[1]][[i]],regexpr(id.xpr,cacm.docs.list[[1]][[i]],perl=TRUE))),
                              Title=ifelse(identical(regmatches(cacm.docs.list[[1]][[i]],regexpr(title.xpr,cacm.docs.list[[1]][[i]],perl=TRUE)),character(0)),NA,regmatches(cacm.docs.list[[1]][[i]],regexpr(title.xpr,cacm.docs.list[[1]][[i]],perl=TRUE))),
                              Author=ifelse(identical(regmatches(cacm.docs.list[[1]][[i]],regexpr(author.xpr,cacm.docs.list[[1]][[i]],perl=TRUE)),character(0)),NA,regmatches(cacm.docs.list[[1]][[i]],regexpr(author.xpr,cacm.docs.list[[1]][[i]],perl=TRUE))),
                              Date=ifelse(identical(regmatches(cacm.docs.list[[1]][[i]],regexpr(date.xpr,cacm.docs.list[[1]][[i]],perl=TRUE)),character(0)),NA,regmatches(cacm.docs.list[[1]][[i]],regexpr(date.xpr,cacm.docs.list[[1]][[i]],perl=TRUE))),
                              Content=ifelse(identical(regmatches(cacm.docs.list[[1]][[i]],regexpr(content.xpr,cacm.docs.list[[1]][[i]],perl=TRUE)),character(0)),NA,regmatches(cacm.docs.list[[1]][[i]],regexpr(content.xpr,cacm.docs.list[[1]][[i]],perl=TRUE))),
                              stringsAsFactors = FALSE)
        cacm.docs<-rbind(cacm.docs,cacm.file)
    }
    
    # Strip Month etc.
    cacm.docs$Date<-gsub("[^0-9]","",cacm.docs$Date)
    
  return(cacm.docs)
}

