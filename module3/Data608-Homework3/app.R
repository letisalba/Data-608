## app.R ##
library(shiny)
library(tidyverse)
library(ggplot2)
library(rsconnect)
library(plotly)

data <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv", header = TRUE)

data %>% 
  select(ICD.Chapter) %>% 
  distinct() %>% 
  arrange(ICD.Chapter) %>% 
  drop_na()


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Question 1", tabName = "Question_1"),
      menuItem("Question 2", tabName = "Question_2")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Question_1",
              h2("Question 1 Content")
      ),
      tabItem(tabName = "Question_2",
              h2("Question 2 Content"))
    )
  )
)

server <- function(input,output,server){
  output$fig <- renderPlot({
    infec_diseases %>% plot_ly() %>% 
      add_trace(x = ~Crude.Rate, y = ~State, type = 'bar', 
                text = 'y', textposition = 'auto', 
                marker = list(color = 'rgb(158,202,225)', 
                              line = list(color = 'rgb(8,48,107)', width = 1.5))) %>% 
      layout(title = "Certain infectious and parasitic diseases",
             barmode = 'group',
             xaxis = list(title = "Crude rate"),
             yaxis = list(title = "States"))
    
  })
  
  outout$fig_2 <- renderPlot({
    state = "CA"
    infec_diseases_2 %>%
      as_tibble()  %>% 
      filter(., State == state) %>% 
      select(., Year, Crude.Rate, Crude.Rate_2) %>%
      plot_ly(x = ~Year, y = ~Crude.Rate, type='bar',
              text = ~Crude.Rate, textposition = 'auto',
              marker = list(color = 'rgb(158,202,225)'), 
              name = 'State') %>% 
      add_trace(x = ~Year, y = ~Crude.Rate_2, type='bar',        
                text = ~Crude.Rate_2, textposition = 'auto',
                marker = list(color = 'rgb(58,200,225)'), name = 'US')  %>%
      layout(title = "Crude death rate by state [CA]",
             barmode = 'group',
             xaxis = list(title = "Year"),
             yaxis = list(title = "Crude rate"))
    
  })
}

shinyApp(ui,server)

# ui <- dashboardPage(
#   dashboardHeader(title = "Data 608 - Homework 3"),
#   
#   dashboardSidebar(
#     selectInput("v_diseases", "ICD.Chapter", choices = infec_diseases %>% 
#                   filter(data, Year == '2010' & ICD.Chapter == 'Certain infectious and parasitic diseases') %>% 
#                   arrange(Crude.Rate) %>% 
#                   drop_na())
#   ),
#   dashboardBody(
#     fluidPage(box(plotOutput("fig_1")), box(plotOutput("fig_2")))
#     #fluidRow(box(plotOutput("coffee_dif")), box(tableOutput("coffee_table")))
#   )
# )
# 
# server <- function(input, output) { 
#   
#   output$fig_1 <- renderPlot({
#     
#     infec_diseases %>% plot_ly() %>% 
#       add_trace(x = ~Crude.Rate, y = ~State, type = 'bar', 
#                 text = y, textposition = 'auto', 
#                 marker = list(color = 'rgb(158,202,225)', 
#                               line = list(color = 'rgb(8,48,107)', width = 1.5))) %>% 
#       layout(title = "Certain infectious and parasitic diseases",
#              barmode = 'group',
#              xaxis = list(title = "Crude rate"),
#              yaxis = list(title = "States"))
#   })
#   
#   output$fig_2 <- renderPlot({
#     
#     state = "CA"
#     infec_diseases_2 %>%
#       as_tibble()  %>% 
#       filter(., State == state) %>% 
#       select(., Year, Crude.Rate, Crude.Rate_2) %>%
#       plot_ly(x = ~Year, y = ~Crude.Rate, type='bar',
#               text = ~Crude.Rate, textposition = 'auto',
#               marker = list(color = 'rgb(158,202,225)'), 
#               name = 'State') %>% 
#       add_trace(x = ~Year, y = ~Crude.Rate_2, type='bar',        
#                 text = ~Crude.Rate_2, textposition = 'auto',
#                 marker = list(color = 'rgb(58,200,225)'), name = 'US')  %>%
#       layout(title = "Crude death rate by state [CA]",
#              barmode = 'group',
#              xaxis = list(title = "Year"),
#              yaxis = list(title = "Crude rate"))
#   })
# 
# }
# 
# shinyApp(ui, server)



--------------------------------------------------------------------------------
#   
#   This R Markdown document is made interactive using Shiny. Unlike the more traditional workflow of creating static reports, you can now create documents that allow your readers to change the assumptions underlying your analysis and see the results immediately. 
# 
# To learn more, see [Interactive Documents](http://rmarkdown.rstudio.com/authoring_shiny.html).
# 
# ## Inputs and Outputs
# 
# You can embed Shiny inputs and outputs in your document. Outputs are automatically updated whenever inputs change.  This demonstrates how a standard R plot can be made interactive by wrapping it in the Shiny `renderPlot` function. The `selectInput` and `sliderInput` functions create the input widgets used to drive the plot.
# 
# ```{r eruptions, echo=FALSE}
# inputPanel(
#   selectInput("n_breaks", label = "Number of bins:",
#               choices = c(10, 20, 35, 50), selected = 20),
#   
#   sliderInput("bw_adjust", label = "Bandwidth adjustment:",
#               min = 0.2, max = 2, value = 1, step = 0.2)
# )
# 
# renderPlot({
#   hist(faithful$eruptions, probability = TRUE, breaks = as.numeric(input$n_breaks),
#        xlab = "Duration (minutes)", main = "Geyser eruption duration")
#   
#   dens <- density(faithful$eruptions, adjust = input$bw_adjust)
#   lines(dens, col = "blue")
# })
# ```
# 
# ## Embedded Application
# 
# It's also possible to embed an entire Shiny application within an R Markdown document using the `shinyAppDir` function. This example embeds a Shiny application located in another directory:
# 
# ```{r tabsets, echo=FALSE}
# shinyAppDir(
#   system.file("examples/06_tabsets", package = "shiny"),
#   options = list(
#     width = "100%", height = 550
#   )
# )
# ```
# 
# Note the use of the `height` parameter to determine how much vertical space the embedded application should occupy.
# 
# You can also use the `shinyApp` function to define an application inline rather then in an external directory.
# 
# In all of R code chunks above the `echo = FALSE` attribute is used. This is to prevent the R code within the chunk from rendering in the document alongside the Shiny components.
# 
# 
# 
# 
