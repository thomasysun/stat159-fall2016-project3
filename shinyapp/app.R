

library(ggplot2)

clean_2012 <- readRDS("../data/clean_2012.rds")

colnames(clean_2012) <- c("College Name", "School Type", "Total Students", "Percentage of White", "Percentage of Black",
                          "Percentage of Hispanic", "Percentage of Asian", "Percentage of American Indian",
                          "Percentage of non-Residential Alien", "4-year Completion Rate", "10-year Aggregate Earnings",
                          "Students in Low Income Family", "Students in Mid Income Family", "Students with Federal Loans",
                          "First Generation Students", "Cost of Attendance", "Average SAT Score")

ui <- fluidPage(
  titlePanel("School Data"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(3,
           selectInput("man",
                       "School Name:",
                       c("All",
                         unique(as.character(clean_2012$"College Name"))))
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
      data <- data[data$'College Name' == input$man,]
    }
    data
  }))
  
}

shinyApp(ui, server)