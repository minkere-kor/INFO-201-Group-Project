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
                 sidebarPanel(tags$h3("What are Why Are We Doing This?"),
                              HTML("The purpose of this project is to investiage <b>relevant factors</b> that 
                                   may affect employee absenteeism. The project will help increase firm's productivity
                                   and employee retention. <br/><br/>
                                   These findings will help the organization make decisions tht can better
                                   support their employees"),
                              tags$hr(),
                              tags$h3("Target Group"),
                              HTML("The intended audience of this project are the Human Resources (HR) department,
                                   the Finances department, and executives. <br/><br/>
                                   The HR department is responsible for employee retention. The Finances department
                                   oversees the organization's assets. They can fund resources that can aid employees'
                                   well-being. Executives have the final say in this investment."),
                              tags$hr(),
                              tags$h3("Overview of Data"),
                              HTML("The dataset includes the <i>date of absence, reason for absence, distance to work,
                                   transportation expenses, </i> and other personal identifying characteristics
                                   such as <i>height</i> and <i>education level.</i> <br/><br/>
                                   This dataset was retrieved from <b><u>UCI's Machine Learning Repository</u></b>.")),
                 mainPanel()
               )),
      
      tabPanel("Question 1",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      
      tabPanel("Question 2",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      
      tabPanel("Question 3",
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
