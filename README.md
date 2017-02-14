# CACM TrecEval From R with Solr

The R files from this repo are functions that allow you to do simple Information Retrieval experiments using the [CACM collection](https://ecommons.cornell.edu/handle/1813/6401) from R with [Apache Solr](http://lucene.apache.org/solr/). 

For connecting to the Solr server and doing basic indexing and querying the R solr client [Solrium](https://github.com/ropensci/solrium) is used.

The aim of this project is to use it in undergrad IR teaching to give students a feel of how different combinations of Tokenizers and Filters from Solr effect retrieval quality.

# Setup
To use the functions and do experiments you have to:

1. Install Solr
2. Download and Install (make) [Trec Eval](http://trec.nist.gov/trec_eval/)
(Be sure that trec_eval can be called from anywhere on your machine)

## Configure Solr 
For comparing different indexing procedures got to Solrs configurations folder ```~/solr-6.4.0/server/solr/configsets/conf``` and prepare different versions of Solrs ```schema.xml```. To be able to manually edit the ```schema.xml``` the ```solrconfig.xml``` has to be updated according to the [Solr documentation](https://cwiki.apache.org/confluence/display/solr/Schema+Factory+Definition+in+SolrConfig). You basically have to add the following line:

```{xml, include=F,show=T}
<schemaFactory class="ClassicIndexSchemaFactory" />
```
Note that you don't have to build specific fields as all fields are getting copied to the default search field/ catch_all field ```<field name="text" type="text_general ... </field>``` 
One thing you have to watch out for is to change the ```<uniqueKey>``` according to your docIDs.

```{xml, include=F,show=T}
<uniqueKey>ID</uniqueKey>

<field name="text" type="text_general" indexed="true" stored="false" multiValued="true"/>

    <fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.SynonymFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
    </fieldType>
```
After this you are good to go to make multiple copies of any of the included config sets e.g. the ```basic_configs``` folder and rename them to a base core name e.g. ```cacm_config_1``` ```cacm_config_2``` ```cacm_config_3``` all with its own configuration and indexing procedure defined in the ```<fieldTye name="text_general" ... </fieldType>``` of every ```schema.xml```. 



## Use the functions 
The total pipeline of function calls for a complete run is documented in ```doTrecEval.R```.

First of all we have to load the CACM collection into R. We do so by using```parseCacmAll()``` which generates a data.frame where every row of the data.frame represents a document of the CACM collection.
```{r, include=F,show=T}
cacm.docs<-parseCacmAll("cacm/cacm.all")
```
Next me generate different cores based on the configsets we prepared. The function ```makeMultipleIndexes```takes four arguments: The number of indexes you want to make, the base config name  (cacm_config)  and what the cores name should be (cacm_core). Finally we pass in the data.frame with the CACM docs for indexing. 
```{r, include=F,show=T}
makeMultipleIndexes(3,"cacm_config","cacm_core",cacm.docs) 
```

Import the queries from the CACM test set:
```{r, include=F,show=T}
queries <- read_delim("cacm/title.query", "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(queries)<-"Query"
queries$Query<-gsub('[[:digit:]]+', '', queries$Query)
```
Query all cores with all CACM queries and write a result file for every core
```{r, include=F,show=T}
queryAndWriteResults(3,"cacm_core",queries)
```
Nex call ```trec_eval``` to measure the result of your cores which gives you precision, recall etc. The ```callTrecEval``` script uses the list of documents relevant to each query from the file ```cacm.qrels```. It will write a trec_eval result file for every file in ```results```. You will note that ```trec_eval```is called with parameter ```-q```` which gives the result for every query.
```{r, include=F,show=T}
callTrecEval("/cacm/cacm.qrels","results","cacm_core","trec_eval_results")
```
Finally make one big data.frame with the results of all trec_eval result files by calling ```loadTrecEvalResults```
```{r, include=F,show=T}
results<-loadTrecEvalResults("trec_eval_results")
```
Based on the results you can make nifty topic by topic comparison plots like these:

![Result Plots from The Solr CACM runs](https://github.com/meier-flo/CACMTrecEvalFromRwithSolr/blob/master/cacm-results.png)


