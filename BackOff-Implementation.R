# Implement n gram analysis

source("Ngram.R")
source("Data-ETL.R")


if (!exists("rawFromETL") || !(length(rawFromETL) > 0))
{
  rawFromETL <- GetData("D:\\Lab\\Final\\final\\en_US")
} 

oneGram <-  GetNGram(rawFromETL,1)
# twoGram <-  GetNGram(rawFromETL,2)
# threeGram <-  GetNGram(rawFromETL,3)
# fourGram <-  GetNGram(rawFromETL,4)

# implementing stupid backoff method