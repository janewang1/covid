  library(stm)
  library(tm)
  library("ldatuning")
  library("topicmodels")
  library("corpus")
  library(LDAvis)
  library(lda)
  library(plyr)
  library(readr)
  
  # i = 1
  # paste("words", i) <- c(paste("words", i), "hiii")
  # print(paste("words", i))
  # 
  # for(i in 1:3){
  #   assign(paste("a", i, sep = ""), i)    
  # }
  # print(a2)
  
  setwd("C:/Users/janew/.PyCharmEdu2018.3/config/scratches/CORD2020/rerun")
  mydir = "C:/Users/janew/.PyCharmEdu2018.3/config/scratches/CORD2020/rerun/output"
  myfiles = list.files(mydir, pattern="*.csv", full.names = TRUE)
  count = 3
  
  #get file name
  for (i in 1:length(myfiles)) {
    
    #filename 
    name <- myfiles[i]
    name <- gsub(".*test/", "", name)
    fileName <- gsub(".csv", "", name)
    print(fileName)

  
    #load data
    reviews <- read.csv(myfiles[i])
    hi<- reviews
    reviews <- reviews$Content
    reviews <- gsub('[[:digit:]]+', "", reviews) # remove numbers
  
    #stop words
    stop_words <- stopwords("SMART")
    customList <- c("covid", "sars", "corona", "mers", "coronavirus", "cov")
  
    #pre-processing
    reviews <- gsub("'", "", reviews)  # remove apostrophes
    reviews <- gsub("[[:punct:]]", " ", reviews)  # replace punctuation with space
    reviews <- iconv(reviews, 'utf-8', 'ascii', sub='')
    reviews <- gsub("[[:cntrl:]]", " ", reviews)  # replace control characters with space
    reviews <- gsub("^[[:space:]]+", "", reviews) # remove whitespace at beginning of documents
    reviews <- gsub("[[:space:]]+$", "", reviews) # remove whitespace at end of documents
    reviews <- tolower(reviews)  # force to lowercase
    
    #tokenize on space, output as a list
    doc.list <- strsplit(reviews, "[[:space:]]+")
    
    #compute table of terms
    term.table <- table(unlist(doc.list))
    term.table <- sort(term.table, decreasing = TRUE)
    
    #remove terms that are stop words or occur less than 5 times
    del <- names(term.table) %in% stop_words | names(term.table) %in% customList | term.table < 5
    term.table <- term.table[!del]
    vocab <- names(term.table)
    
    #put the documents into the format required by the lda package
    get.terms <- function(x) {
      index <- match(x, vocab)
      index <- index[!is.na(index)]
      rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
    }
    documents <- lapply(doc.list, get.terms)
    
    
    D <- length(documents)  # number of documents (2,000)
    W <- length(vocab)  # number of terms in the vocab (14,568)
    doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
    N <- sum(doc.length)  # total number of tokens in the data (546,827)
    term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus 
    
    #MCMC and model tuning parameters:
    K <- 20
    G <- 2000
    alpha <- 0.02
    eta <- 0.02
    
    set.seed(357)
    t1 <- Sys.time()
    fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                       num.iterations = G, alpha = alpha, 
                                       eta = eta, initial = NULL, burnin = 0,
                                       compute.log.likelihood = TRUE)
    t2 <- Sys.time()
    t2 - t1
    
    theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
    phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))
    
    covidmodel <- list(phi = phi,
                         theta = theta,
                         doc.length = doc.length,
                         vocab = vocab,
                         term.frequency = term.frequency)
    
    top.words <- top.topic.words(fit$topics, 10, by.score=TRUE)
    #write.csv(top.words, "C:/Users/janew/.PyCharmEdu2018.3/config/scratches/CORD2020/rerun/proportions.csv",row.names=FALSE)
    #print(top.words[4,1])
    
    for (i in 1:20){
      words <- ""
      words <- paste(words,"Topic ")
      words <- paste(words, i)
      words <- paste(words,":", sep="")
      

      for (j in 1:10) {
        #print(top.words[j,i])
        words <- paste(words,top.words[j,i])
        words <- paste(words,",", sep="")
      }
      assign(paste("topic", i, sep=""), words)
    }
    #print(topic3)
    Topics <- data.frame(topic1, topic2, topic3, topic4, topic5, topic6, topic7, topic8, topic9, topic10, topic11, topic12, 
                         topic13, topic14, topic15, topic16, topic17, topic18, topic19, topic20)
    
    #df.to_csv('filename.csv', header=False)
    
    #create JSON object to feed into the interface
    json <- createJSON(phi = covidmodel$phi, 
                       theta = covidmodel$theta, 
                       doc.length = covidmodel$doc.length, 
                       vocab = covidmodel$vocab, 
                       term.frequency = covidmodel$term.frequency)
  
    #create interface
    directry <- paste("interface-", count, sep="")
    my_dir <- dir.create(directry)
    serVis(json, out.dir = directry, open.browser = TRUE)
  
    fname <- paste("C:/Users/janew/.PyCharmEdu2018.3/config/scratches/CORD2020/rerun/interface-", count, "/topics.csv", sep="")
    print(fname)
    write.table(Topics, fname, sep=",")
    
    #proportions
    dt <- make.dt(covidmodel, meta=hi)
    csvfilename <- paste("C:/Users/janew/.PyCharmEdu2018.3/config/scratches/CORD2020/rerun/interface-", count, "/proportions.csv", sep="")
   
    #print(csvfilename)
    write.csv(dt, csvfilename, row.names=FALSE)
    

    count = count + 1
  
  }