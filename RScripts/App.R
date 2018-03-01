source("helpers.R")
counties <- read.csv("data/rdata.csv")
library(maps)
library(mapproj)

# User interface ----
ui <- fluidPage(
  titlePanel("CancerVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create predictive incidence maps using the most important factors"),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Lung Cancer", "Total Cancer"),
                  selected = "Lung Cancer"),
      
      sliderInput("range", 
                  label = "Cancer Incidence Range:",
                  min = 1, max = 5, value = c(1, 5)),
      
      sliderInput("smoking", 
                  label = "Smoking Level:",
                  min = 0, max = 2, value = 1, step=0.1),
      
      sliderInput("diabetes", 
                  label = "Limited Exercise:",
                  min = 0, max = 2, value = 1, step=0.1),
      
      sliderInput("pm", 
                  label = "PM 2.5 Level:",
                  min = 0, max = 2, value = 1, step=0.1),
      
      sliderInput("BP", 
                  label = "Chemical: DEHP Emitted",
                  min = 0, max = 2, value = 1, step=0.1),
      
      sliderInput("hisp", 
                  label = "Chemical: MTBE Emitted",
                  min = 0, max = 2, value = 1, step=0.1)
      
      ),

    
    
    mainPanel(plotOutput("map"))
  )
  )

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Lung Cancer" = counties$Cancer)
    
    color <- switch(input$var, 
                    "Lung Cancer" = "darkgreen")
    
    legend <- switch(input$var, 
                     "Lung Cancer" = "Cancer Level")
    
    
    
    percent_map(data, color, legend, input$range[1], input$range[2], input$smoking, input$diabetes, input$pm, input$BP, input$hisp)
  })
}

# Run app ----
shinyApp(ui, server)