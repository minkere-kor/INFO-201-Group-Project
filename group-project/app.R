#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(colorspace)
library(rsconnect)

absent <- read_delim("absenteeism.csv")

ui <- fluidPage(

    titlePanel("Absenteeism in the Workplace"),

    tabsetPanel(
      tabPanel("About",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      tabPanel("Plots",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      tabPanel("Table",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      tabPanel("Conclusion",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               ))
    )
)

server <- function(input, output) {


}

shinyApp(ui = ui, server = server)
