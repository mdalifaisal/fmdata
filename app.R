library(shiny)

library(shiny)
library(quantmod)

symbols <- c("SPX", "EURUSD=X", "CDX.NA.IG")
start_date <- as.Date("1900-01-01")

ui <- fluidPage(
        titlePanel("FM DATA"),
        sidebarLayout(
                sidebarPanel(
                        actionButton("download_button", "Download Data")
                ),
                mainPanel(
                        # Add other UI elements here
                )
        )
)

server <- function(input, output) {
        observeEvent(input$download_button, {
                for (symbol in symbols) {
                        getSymbols(symbol, src = "yahoo", from = start_date)
                        write.csv(get(symbol), file = paste0(symbol, ".csv"))
                }
                showModal(modalDialog(
                        title = "Download Complete",
                        "Data downloaded successfully!"
                ))
        })
}

shinyApp(ui, server)
