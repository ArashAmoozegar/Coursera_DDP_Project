library(shiny)

SP_500 = read.csv("SP500_List.csv", stringsAsFactors = FALSE, header = FALSE, col.names = c("Ticker"))

shinyUI (
        pageWithSidebar (
                headerPanel (strong(("News Sentiment Analysis"))),
                sidebarPanel (tags$style(type = "text/css", "#loadmessage {
                                             position: fixed;
                                             top: 228px;
                                             left: 70px;
                                             width: 20%;
                                             padding: 5px 0px 5px 0px;
                                             text-align: center;
                                             font-weight: bold;
                                             font-size: 100%;
                                             color: #DC143C;
                                             background-color: DC143C;
                                             z-index: 105;
                                             }
                                             "),
                        #textInput("StockTicker", label = h3("Stock Ticker"), value = ""),
                        helpText("This app allows you to find the news sentiment for a stock from S&P500 list of stocks. The app parses the 20 most recent news articles and matches the words used in each of the articles to words in 8 different categories in a famous content analysis dictionary created called Harvard General Inquirer. Next, it calculates the average of the scores from 4 ratios and reports it as the overall sentiment."),
                        helpText("Select your stock from the following list and click the Submit button. In few seconds, you will see the overall sentiment of news articles for your stock along with a measure of relative positivity of articles on the right. The app also provides you with the meta data and the content of the most recent article."),
                        selectInput("Dataset", "Pick Your Stock:", as.list(SP_500)),
                        submitButton('Submit'),
                        conditionalPanel(condition = "$('html').hasClass('shiny-busy')",
                                         tags$div("Parsing, Please Wait ...", id = "loadmessage"))
                ),
                mainPanel (
                        h3 ("Stock Sentiment: "),
                        textOutput("Stock_Sentiment_W"),
                        textOutput("Stock_Sentiment"),
                        #h3 ("Word Categories: "),
                        #DT::dataTableOutput("News_Table"),
                        h3 ("Latest News for Your Stock"),
                        h4 ("* News Source: "),
                        textOutput("News_Source"),
                        h4 ("* News Timestamp: "),
                        textOutput("News_Timestamp"),
                        h4 ("* News Header: "), 
                        textOutput("News_Header"),
                        h4 ("* News Article: "),
                        htmlOutput("News_Article")
                )
        )
        
)