# Implement n gram analysis

source("Ngram.R")
source("Data-ETL.R")


if (!exists("rawFromETL") || !(length(rawFromETL) > 0))
{
  rawFromETL <- GetData("en_US")
} 

oneGram <-  GetNGram(rawFromETL,1)
head(oneGram)

twoGram <-  GetNGram(rawFromETL,2)
head(twoGram)

threeGram <-  GetNGram(rawFromETL,3)
head(threeGram)

fourGram <-  GetNGram(rawFromETL,4)
head(fourGram)

fiveGram <-  GetNGram(rawFromETL,5)
head(fiveGram)

# implementing stupid backoff method