library(shiny)
library(DT)
library(ggplot2)
library(palmerpenguins)
library(dplyr)
library(rsconnect)

ui <- fluidPage(
  titlePanel("펭귄 데이터 분석"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("species", "펭귄 종류를 선택하세요",
                         choices = list("Adelie" = "Adelie", 
                                        "Gentoo" = "Gentoo", 
                                        "Chinstrap" = "Chinstrap"),
                         selected = "Adelie"),
      
      selectInput("xcol", "x축을 선택하세요.",
                  choices = names(penguins)[3:6],
                  selected = "bill_length_mm"),
      
      selectInput("ycol", "y축을 선택하세요.",
                  choices = names(penguins)[3:6],
                  selected = "body_mass_g"),
      
      sliderInput("size", "점 크기를 선택하세요",
                  min = 1, max = 10, value = 5)
    ),  
    
    mainPanel(
      dataTableOutput('dynamic'),
      plotOutput('ggplot')
    )
  )
)

server <- function(input, output, session) {
  filteredData <- reactive({
    penguins %>%
      filter(species %in% input$species)
  })
  
  output$dynamic <- renderDataTable({
    filteredData() %>% datatable()
  })
  
  output$ggplot <- renderPlot({
    ggplot(filteredData(), aes_string(x = input$xcol, y = input$ycol, shape = "sex", color = "species")) +
      geom_point(size = input$size)
  })
}

shinyApp(ui = ui, server = server)