library(shiny)
library(quantmod)

# Define UI
ui <- fluidPage(
        sidebarLayout(
                sidebarPanel(
                        selectInput("currency", "Select Currency",
                                    choices = c("GBPUSD=X", "JPY=X", "MXN=X",
                                                "EURUSD=X", "ARS=X", "MYRUSD=X",
                                                "BRL=X", "HKD=X", "IDR=X", "KRW=X")),
                        dateRangeInput("dates", "Select Dates"),
                        downloadButton("downloadData", "Download")
                ),
                mainPanel(
                        tableOutput("data")
                )
        )
)

# Define server
server <- function(input, output) {
        
        # Download data from yahoo finance
        data <- reactive({
                getSymbols.yahoo(input$currency,
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE, 
                                 return.class = 'xts',
                                 index.class = 'Date')
        })
        
        # Format the date
        output_format <- "%Y-%m-%d"
        output_data <- reactive({
                format(index(data()), output_format)
        })
        
        # Combine the date with the data and output in a table format
        output$data <- renderTable({
                data.frame(Date = output_data(), data(), row.names = NULL, check.names = FALSE)
        })
        
        # Download data in CSV format
        output$downloadData <- downloadHandler(
                filename = function() {
                        paste(input$currency, ".csv", sep = "")
                },
                content = function(file) {
                        write.csv(data.frame(Date = output_data(), data(), row.names = NULL, check.names = FALSE), file)
                }
        )
}

# Run the app
shinyApp(ui = ui, server = server)
