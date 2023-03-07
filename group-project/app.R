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
                                   
                                   These findings will help the organization make decisions that can better
                                   support their employees."),
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
                                   transportation expense, </i> and other personal identifying characteristics
                                   such as <i>height</i> and <i>education level.</i> <br/><br/>
                                   
                                   This dataset was retrieved from <b><u>UCI's Machine Learning Repository</u></b>.")),
                 mainPanel(tags$img(src = "hr-2.jpg"))
               )),
      
      tabPanel("Question 1",
               sidebarLayout(
                 sidebarPanel(tags$h3("Distance and Transportation Expense"),
                              HTML("The factors that will be examined in the first question are commute-related variables
                                   and absences. That is, is there a relationship betweem <b><u>distance from residence to work</u></b> 
                                   AND <b><u>absences</u></b>? Is <b><u>transportation expense</u></b> correlated
                                   with <b><u>absences</u></b>? <br/><br/>
                                   
                                   Multiple studies have shown that there is a correlation between commute distance
                                   and absences. <br/><br/>
                                   
                                   This interactive page will test if this claim is applicable
                                   to the firm's circumstances. In addition, transportation expense
                                   will also be evaluated as costs may pose a barrier for employees to
                                   go to the workplace. <br><br/>
                                   
                                   Below, the following widgets are <i>Variable Selection, Data Range Slider, and 
                                   Trend Line Toggle.</i> <br/><br/>
                                   
                                   <b>Variable Selection</b> allows users to change the independent variable
                                   (<i>distance from residence to work</i> OR <i>transportation expense</i>)
                                   and compare it with the dependent variable (<i>absences</i>). <br/><br/>
                                   
                                   <b>Data Range Slider</b> gives users the ability to modify
                                   the scope of values. <br/><br/>
                                   
                                   <b>Trend Line Toggle</b> permits users to turn on and off
                                   the trend line in the plot."),
                              tags$hr(),
                              tags$h4("Variable Selection"),
                              selectInput("variable", "Choose one:", 
                                          choices = c("Transportation_expense", 
                                                      "Distance_from_Residence_to_Work")),
                              tags$hr(),
                              tags$h4("Data Range Slider"),
                              uiOutput("slider"),
                              tags$hr(),
                              tags$h4("Trend Line Toggle"),
                              checkboxInput("toggle", "Show trend line", value = FALSE)),
                 mainPanel(plotOutput("plots"))
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
    subsetData1 <- reactive({
      absent %>% 
        filter(Transportation_expense >= input$n[1], 
               Transportation_expense <= input$n[2])
    })
        
    subsetData2 <- reactive({
      absent %>% 
        filter(Distance_from_Residence_to_Work >= input$n[1], 
               Distance_from_Residence_to_Work <= input$n[2])
    })
    
    output$slider <- renderUI({
      minimum <- absent %>% 
        summarize(min = min(.data[[input$variable]])) %>% 
        pull()
      
      maximum <- absent %>% 
        summarize(max = max(.data[[input$variable]])) %>% 
        pull()
      
      q1 <- absent %>% 
        summarize(lower = quantile(.data[[input$variable]], p = 0.25)) %>% 
        pull()
      
      q3 <- absent %>% 
        summarize(upper = quantile(.data[[input$variable]], p = 0.75)) %>% 
        pull()
    
      sliderInput("n", "Select a range:", min = minimum, max = maximum, value = c(q1, q3))
   })
  
    plot1 <- reactive({
      total_abs <- subsetData1() %>%
        group_by(ID) %>%
        count(Reason_for_absence) %>%
        summarize(total_absences = sum(n))
      
      expense <- subsetData1() %>% 
        distinct(ID, Transportation_expense)
      
      absence_expense <- merge(expense, total_abs)
      
      p <- absence_expense %>% 
        ggplot(aes(Transportation_expense, total_absences, col=factor(ID))) + 
        geom_point() +
        labs(title="Transportation Expenses and Total Absences", x="Transportation Expenses", 
             y="Total Absences", col="Employee ID")
      
      if(input$toggle == TRUE) {
        p + geom_smooth(aes(group = 1), method = "lm")
      } else {
        p
      }
      
    })    
    
  plot2 <- reactive({
    total_abs <- subsetData2() %>%
      group_by(ID) %>%
      count(Reason_for_absence) %>%
      summarize(total_absences = sum(n))

    distance <- subsetData2() %>%
      distinct(ID, Distance_from_Residence_to_Work)

    absence_distance <- merge(distance, total_abs, by = "ID")

    p <- absence_distance %>%
      ggplot(aes(Distance_from_Residence_to_Work, total_absences, col=factor(ID))) +
      geom_point() +
      labs(title="Distance to Work and Total Absences", x="Distance from Residence to Work",
           y="Total Absences", col="Employee ID")
    
    if(input$toggle == TRUE) {
      p + geom_smooth(aes(group = 1), method = "lm")
    } else {
      p
    }
    
  })
  
  output$plots <- renderPlot({
    if(input$variable == "Transportation_expense") {
      plot1()
    } else {
      plot2()
    }
  })

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
