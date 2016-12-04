
library(ggplot2)

clean_2012 <- readRDS("../data/clean_2012.rds")

ui <- fluidPage(
  titlePanel("School Data"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(3,
           selectInput("man",
                       "School Name:",
                       c("All",
                         unique(as.character(clean_2012$CollegeName))))
    )

  ),
  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
  )
)


server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- clean_2012
    if (input$man != "All") {
      data <- data[data$CollegeName == input$man,]
    }
    data
  }))
  
}

shinyApp(ui, server)