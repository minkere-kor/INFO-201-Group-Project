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

total_abs <- absent %>% 
  group_by(ID) %>% 
  count(Reason_for_absence) %>% 
  summarize(total_absences = sum(n)) 

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
                 mainPanel(tags$img(src = "hr-2.jpg"))
               )),
      
      tabPanel("Question 1",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               )),
      
      tabPanel("Question 2",
               sidebarLayout(
                 sidebarPanel(
                   p("text"),
                   
                   radioButtons("plotSelect",
                                "Select Plot",
                                choices = c("Education", "# of Children", "# of Pets"))
                   
                 ),
                 mainPanel(
                   plotOutput("socPlot"),
                   dataTableOutput("socTable")
                 )
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
## QUESTION 1

## QUESTION 2
  
  output$socPlot <- renderPlot({
    if(input$plotSelect == "Education"){
      currentTable <- absent %>% 
        select(ID, Education) %>% 
        distinct(ID, Education) %>% 
        merge(total_abs, by = "ID")
      
      currentPlot <- currentTable %>% 
        ggplot(aes(Education,
                   total_absences,
                   fill=factor(ID))) +
        geom_col(col="black",
                 width = 0.5) +
        labs(title = "Number of Absences based on Education",
             x = "Education Level",
             y = "Number of Absences",
             fill = "Employee ID") +
        theme(plot.title = element_text(size = 25),
              axis.text = element_text(size = 10),
              axis.title = element_text(size = 20),
              legend.title = element_text(size = 15))
    } 
    
    else if(input$plotSelect == "# of Children"){
      currentTable <- absent %>% 
        select(ID, Son) %>% 
        distinct(ID, Son) %>% 
        merge(total_abs, by = "ID")
      
      currentPlot <- currentTable %>% 
        ggplot(aes(Son,
                   total_absences,
                   fill=factor(ID))) +
        geom_col(col="black",
                 width = 0.5) +
        labs(title = "Number of Absences based on Number of Children",
             x = "Number of Children",
             y = "Number of Absences",
             fill = "Employee ID") +
        theme(plot.title = element_text(size = 25),
              axis.text = element_text(size = 10),
              axis.title = element_text(size = 20),
              legend.title = element_text(size = 15))
    }  
    
    else if(input$plotSelect == "# of Pets"){
      currentTable <- absent %>% 
        select(ID, Pet) %>% 
        distinct(ID, Pet) %>% 
        merge(total_abs, by = "ID")
      
      currentPlot <- currentTable %>% 
        ggplot(aes(Pet,
                   total_absences,
                   fill=factor(ID))) +
        geom_col(col="black",
                 width = 0.5) +
        labs(title = "Number of Absences based on Number of Pets",
             x = "Number of Pets",
             y = "Number of Absences",
             fill = "Employee ID") +
        theme(plot.title = element_text(size = 25),
              axis.text = element_text(size = 10),
              axis.title = element_text(size = 20),
              legend.title = element_text(size = 15))
    }
    currentPlot
  })
  
  output$socTable <- renderDataTable({
    if(input$plotSelect == "Education"){
      currentTable <- absent %>% 
        select(ID, Education) %>% 
        distinct(ID, Education) %>% 
        merge(total_abs, by = "ID")
    } 
    
    else if(input$plotSelect == "# of Children"){
      currentTable <- absent %>% 
        select(ID, Son) %>% 
        distinct(ID, Son) %>% 
        merge(total_abs, by = "ID")
    }
    
    else if(input$plotSelect == "# of Pets"){
      currentTable <- absent %>% 
        select(ID, Pet) %>% 
        distinct(ID, Pet) %>% 
        merge(total_abs, by = "ID")
    }
    
      currentTable %>% 
        arrange(desc(total_absences)) %>% 
        head(10)
  })
  
## QUESTION 3
}

shinyApp(ui = ui, server = server)
