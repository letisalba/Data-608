# load libaries
library(shiny)
library(tidyverse)
library(ggplot2)
library(rsconnect)
library(plotly)

# load data
data <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv", header = TRUE)

# view data
str(data)

summary(data)

colnames(data)

colSums(is.na(data))

rsconnect::setAccountInfo(name='letisalba', token='18C2DF783293E23721636AD4A43F97C6', secret='seSfGaZ7eiF653BaFtyAGHFls/Z66OE/t7Sk2b9A')


infec_diseases <- filter(data, Year == '2010' & ICD.Chapter == 'Certain infectious and parasitic diseases')
infec_diseases <- infec_diseases %>% 
  arrange(Crude.Rate)

fig <- infec_diseases %>% plot_ly()
fig <- fig %>% add_trace(x = ~Crude.Rate, y = ~State, type = 'bar',
                         text = y, textposition = 'auto',
                         marker = list(color = 'rgb(158,202,225)',
                                       line = list(color = 'rgb(8,48,107)', width = 1.5)))
fig <- fig %>% layout(title = "Certain infectious and parasitic diseases",
                      barmode = 'group',
                      xaxis = list(title = "Crude rate"),
                      yaxis = list(title = "States"))


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  # App title ----
  titlePanel("Crude Mortality Rate"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Slider for the number of bins ----
      selectInput(inputId = 'y','Selected ICD.Chapter:',
                  choices = infec_diseases$ICD.Chapter,
                  selected = 'State')
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      plotlyOutput('distPlot', height = "700px", width = "600px")
      
    )
  )
)

# Define server logic required to draw a bargraph
server <- function(input, output) {
  output$distPlot <- renderPlotly({fig})
}

# Run the application
shinyApp(ui, server)