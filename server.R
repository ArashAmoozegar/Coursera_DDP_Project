library(shiny)
library(tm)
library(tm.plugin.webmining)
library(SnowballC)

setwd("./db")

SP_500 = read.csv("SP500_List.csv", stringsAsFactors = FALSE, header = FALSE, col.names = c("Ticker"))
Pos = read.csv("Positive.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Positive")
Neg = read.csv("Negative.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Negative")
Sng = read.csv("Strong.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Strong")
Wek = read.csv("Weak.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Weak")
Act = read.csv("Active.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Active")
Pas = read.csv("Passive.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Passive")
Ost = read.csv("Overstated.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Overstated")
Ust = read.csv("Understated.csv", stringsAsFactors = FALSE, header = FALSE, col.names = "Understated")

shinyServer(
        function(input, output) {
                Input_Ticker <- reactive ({
                        Input_Ticker <- input$Dataset
                })
                GOOG_FIN <- reactive ({
                        ticker <- paste("NYSE:",Input_Ticker())
                        GOOG_FIN <- WebCorpus(GoogleFinanceSource(ticker))
                })
                ds4g <- reactive ({
                        ds1g <- tm_map(GOOG_FIN(), content_transformer(tolower))
                        ds2g <- tm_map(ds1g, removePunctuation)
                        ds3g <- tm_map(ds2g, stripWhitespace)
                        ds4g <- tm_map(ds3g, removeNumbers)
                })
                News_Content <- reactive ({
                        News_Content <- lapply(GOOG_FIN(), "[[", "content")
                })
                News_Meta <- reactive ({
                        News_Meta <- lapply(ds4g(), "[[", "meta")
                })
                News_Sentiment <- reactive ({
                        DTM <- DocumentTermMatrix(ds4g())
                        Terms <- colnames(DocumentTermMatrix(ds4g()))
                        
                        Pos_Terms <- Terms[Terms %in% Pos[,1]]
                        Pos_Scores <- rowSums(as.matrix(DTM[,Pos_Terms]))
                        
                        Neg_Terms <- Terms[Terms %in% Neg[,1]]
                        Neg_Scores <- rowSums(as.matrix(DTM[,Neg_Terms]))
                        
                        Act_Terms <- Terms[Terms %in% Act[,1]]
                        Act_Scores <- rowSums(as.matrix(DTM[,Act_Terms]))
                        
                        Pas_Terms <- Terms[Terms %in% Pas[,1]]
                        Pas_Scores <- rowSums(as.matrix(DTM[,Pas_Terms]))
                        
                        Sng_Terms <- Terms[Terms %in% Sng[,1]]
                        Sng_Scores <- rowSums(as.matrix(DTM[,Sng_Terms]))
                        
                        Wek_Terms <- Terms[Terms %in% Wek[,1]]
                        Wek_Scores <- rowSums(as.matrix(DTM[,Wek_Terms]))
                        
                        Ost_Terms <- Terms[Terms %in% Ost[,1]]
                        Ost_Scores <- rowSums(as.matrix(DTM[,Ost_Terms]))
                        
                        Ust_Terms <- Terms[Terms %in% Ust[,1]]
                        Ust_Scores <- rowSums(as.matrix(DTM[,Ust_Terms]))
                        
                        Pos_Neg <- sum(Pos_Scores) / sum(Neg_Scores)
                        Act_Pas <- sum(Act_Scores) / sum(Pas_Scores)
                        Sng_Wek <- sum(Sng_Scores) / sum(Wek_Scores)
                        Ost_Ust <- sum(Ost_Scores) / sum(Ust_Scores)
                        
                        News_Sentiment <- mean(Pos_Neg, Act_Pas, Sng_Wek, Ost_Ust)
                })
                output$Stock_Sentiment_W <- renderPrint ({
                        if (Input_Ticker() != "STOCK TICKER") {
                                if (News_Sentiment() > 0) {
                                        Stock_Sentiment_W <- "Positive" 
                                } else {
                                        Stock_Sentiment_W <- "Negative"
                                }
                        cat(Stock_Sentiment_W)
                        }
                })
                output$Stock_Sentiment <- renderPrint({
                        News_Sentiment()
                })
                output$Stock_Sentiment <- renderPrint({
                        if (Input_Ticker() != "STOCK TICKER") {
                                cat(round(News_Sentiment(), digits = 2))
                        }
                })
                output$News_Source <- renderPrint ({
                        if (Input_Ticker() != "STOCK TICKER") {
                                cat(News_Meta()[[1]]$origin)
                        }
                }) 
                output$News_Timestamp <- renderPrint ({
                        if (Input_Ticker() != "STOCK TICKER") {
                                cat(paste("", News_Meta()[[1]]$datetimestamp))
                        }
                })
                output$News_Header <- renderPrint ({
                        if (Input_Ticker() != "STOCK TICKER") {
                                cat(News_Meta()[[1]]$heading)
                        }
                })
                output$News_Article <- renderPrint ({
                        if (Input_Ticker() != "STOCK TICKER") {
                                HTML(cat(gsub("\n", "<br/><br/>", News_Content()[[1]])))
                        }
                })
#                 output$News_Table <- renderDataTable (
#                         if (!is.null(Input_Ticker())) {
#                                    News_Table <- data.frame("Category" = 
#                                                  c("Positive", "Negative", "Active", "Passive", 
#                                                  "Strong", "Weak", "Overstated", "Understated"))
#                                    }, options = list(searching = FALSE)
#                  )
        }
)