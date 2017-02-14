install.packages("solrium")
require("solrium")
require("readr")
require("dplyr")
require("ggplot")
source("indexing.R")
source("querying.R")
source("callTrecEval.R")
source("loadTrecEvalResults.R")

pathToSolrServer<-"http://localhost:8983"
solr_connect(solrServer, errors = "complete", verbose = TRUE)

# Parse and load CACM docs into a 
cacm.docs<-parseCacmAll("path/to/doc/file")

# Create Indexes: Tell Solr How many Configs/Index what their base name is 
makeMultipleIndexes(3,"cacm_config","cacm_core",cacm.docs) 

#deleteMultipleIndexes(3,"cacm_core")
#reIndexMultipleIndexes(3,"cacm_core",test.data)

######## Read in the  Queries
queries <- read_delim("~/Dropbox/Lehre/SS17/VSIRSS17/cacm/title.query", "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(queries)<-"Query"
queries$Query<-gsub('[[:digit:]]+', '', queries$Query)

####### Query the Cores and Write Results into results folder
queryAndWriteResults(3,"cacm_core",queries)

####### Run TREV_EVAL an all results
callTrecEval("~/Dropbox/Lehre/SS17/VSIRSS17/cacm/cacm.qrels","~/Dropbox/Lehre/SS17/VSIRSS17/results/","cacm_core","trec_eval_results")

##### Reload the results and make further analysis / polts 
results<-loadTrecEvalResults("trec_eval_results")

####### make some plots e.g  a topic by topic comparison for certain values 
#############

