library(shiny)
library(quantmod)

# Define UI
ui <- fluidPage(
        sidebarLayout(
                sidebarPanel(
                        selectInput("market", "Select Index",
                                    choices = c("^KLSE", "^FTSE", "^N225",
                                                "^MXX", "^MERV", "^BVSP",
                                                "^HSI", "^JKSE", "^KS11",
                                                "^FCHI")),
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
                getSymbols(input$market,src = 'yahoo',
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE)
        })
        
        # Format the date
        output_format <- "%Y-%m-%d"
        output_data <- reactive({
                format(index(data()), output_format,trim=TRUE,digits=NULL,
                       nsmall=6,justify='left',width=NULL,na.encode=FALSE, scientific = TRUE)
        })
        
        # Combine the date with the data and output in a table format
        output$data <- renderTable({
                data.frame(Date = output_data(), data(), row.names = NULL, check.names = FALSE)
        })
        
        # Download data in CSV format
        output$downloadData <- downloadHandler(
                filename = function() {
                        paste(input$market, ".csv", sep = "")
                },
                content = function(file) {
                        write.csv(data.frame(Date = output_data(), data(), row.names = NULL, check.names = FALSE), file)
                }
        )
}

# Run the app
shinyApp(ui = ui, server = server)
