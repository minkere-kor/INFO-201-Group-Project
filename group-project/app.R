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
                sidebarPanel(
                  selectInput("health_factor", label = "Select a Health Factor",
                              choices = c("Service_time", "Age", "Work_load_Average.day", 
                                          "Social.drinker", "Social.smoker", "Weight", 
                                          "Height", "Body_mass_index")),
                  checkboxInput("add_trendline", "Add Trendline", FALSE),
                  tabsetPanel(
                    tabPanel("Plots", plotOutput("health_plot", height = "500px", width = "800px")),
                    tabPanel("Average Time Off", plotOutput("avg_time_plot", height = "500px", width = "800px"))
                  )
                ),
                mainPanel()
              )),
      
      tabPanel("Conclusion",
               sidebarLayout(
                 sidebarPanel(),
                 mainPanel()
               ))
    )
)



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
  server <- function(input, output) {
    filtered_data <- reactive({
      absent %>%
        select(Absenteeism_time_in_hours, input$health_factor)
    })
    
    output$health_plot <- renderPlot({
      plot <- ggplot(filtered_data(), aes_string(x = input$health_factor, y = "Absenteeism_time_in_hours")) +
        geom_point() +
        labs(x = input$health_factor, y = "Absenteeism Time in Hours") +
        annotate("text", x = min(filtered_data()[[input$health_factor]]), 
                 y = -25,
                 label = paste(input$health_factor, "(var number:num of datapoints):", 
                               paste(sapply(unique(filtered_data()[[input$health_factor]]), function(i) {
                                 paste(i, ":", sum(filtered_data()[[input$health_factor]] == i))
                               }), collapse = ", ")),
                 hjust = 0, size = 3) +
        theme(plot.margin = unit(c(1, 1, 3, 1), "lines"))
      
      if (input$add_trendline) {
        plot <- plot + geom_smooth(method = "lm")
      }
      
      plot
    })
    
    output$avg_time_plot <- renderPlot({
      grouped_data <- absent %>% 
        group_by(!!sym(input$health_factor)) %>%
        summarise(avg_time = mean(Absenteeism_time_in_hours))
      
      plot <- ggplot(grouped_data, aes_string(x = input$health_factor, y = "avg_time")) +
        geom_bar(stat = "identity") +
        labs(x = input$health_factor, y = "Average Time Taken Off") +
        annotate("text", x = min(grouped_data[[input$health_factor]]), 
                 y = -2,
                 label = paste(input$health_factor, "(var number:num of datapoints):", 
                               paste(sapply(unique(grouped_data[[input$health_factor]]), function(i) {
                                 paste(i, ":", sum(grouped_data[[input$health_factor]] == i))
                               }), collapse = ", ")),
                 hjust = 0, size = 3) +
        theme(plot.margin = unit(c(1, 1, 3, 1), "lines"))
      
      if (input$add_trendline) {
        plot <- plot + geom_smooth(method = "lm")
      }
      
      plot
    })
}

shinyApp(ui = ui, server = server)
