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
names(absent) <- make.names(names(absent))

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
                                   
                                   When it comes to <u>data quality</u> and <u>reliabilty</u>, the dataset is reliable but 
                                   there are quality issues because we had to be dependent on a key to understand the data. 
                                   Categorical data used numbers when labels and words may be suitable. In addition, there
                                   was a variable in the data set simply called “Son”. While the key says that this is supposed
                                   to mean the number of male or female children that the worker has, it could’ve easily been 
                                   misinterpreted as True/False “Do you have a son” or “How many male children” do you have. <br/><br/>

                                   In regards to whether the data is ethical, We see no ethical issues with using this data
                                   because while there is information that some people might want to keep private, such as BMI,
                                   reasons for absences, etc, everyone is kept entirely anonymous because they can only be
                                   identified by an ID number. <br/><br/>
                                   
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
                                   will also be evaluated as costs may prevent employees from
                                   going to the workplace. <br><br/>
                                   
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
                   HTML("The second question that we tried to answer by analyzing the data set is whether
                   or not social factors, such as education and number of children, impact the amount
                   of absences that a worker has. For example, an employee that has multiple children
                   might have to call in as absent more often than one who doesn't in order to take
                   care of business within his family.
                   
                   <br/><br/>

                   As a result, the variables that we decided to use for analyzing social factors in
                   relation to absences are <b>education</b>, <b>number of children</b>, and <b>number
                   of pets</b>.
                    
                   <br/><br/>
                    
                   The plot on the right can be changed into one of three individual plots through 
                   the use of the <b>Select Plot</b> radio buttons on the side bar panel. Each plot
                   depicts a column plot that catagorizes the employees working at the firm into their
                   level of education, number of children, or number of pets respectively. This allows
                   us to see which categories, as well as individuals in those categories, have the 
                   largest amount of absences
                    
                   <br/><br/>
                    
                   In addition, in order to increase ease of anaylsis, beneath the plot is a table
                   that shows the employee with the highest number of absences for each plot.
                   "),
                   
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
                  HTML("The third question that we tried to answer by analyzing the data set is if health factors,
                  such as social smoking or BMI, impact the amount of absences that a worker has. For example, 
                  an employee that drinks socially may call in more times compared to a worker that doesn't.
                  
                  <br/><br/>
                  
                  To analyse this, we selected <b>service time</b>, <b>age</b>, <b>workload average per day</b>,
                  <b>social drinking and smoking</b>, <b>weight</b>, <b>height</b>, and <b>BMI</b>.
                  
                  <br/><br/>
                  
                  The singular plot can be changed through each of these variables and plots it versus the total
                  number of hours called in for each amount. For example, if nonsmokers called in for 4, 2, 6, 8
                  hours on 4 different occasions, it would plot 4 points at (0, 4), (0, 2), etc. Additionally,
                  we can change the plot to be versus average time taken off for each variable. By doing so, trend
                  lines would not be skewed based on the sheer number of occurrences, and provides a different 
                  view on the data. 
                  
                  <br/><br/>
                  
                  Furthermore, a trendline can be toggled on and off. Due to the amount of data, 
                  it can be hard to analyse by eye, so a trendline is added to show if there is correlation between
                  the variables or not. A sentence adding the variable name, as well as the number of datapoints for
                  each variable level is added under the plot.
                  
                  <br/><br/>
                  
                  Many of the variables do not have any correlation when plotted versus total number of absence hours.
                  The few variables that we found have a correlation was height (positive) and BMI (negative). However
                  when comparing versus average time off, we see that there are slight correlations for service time 
                  (positive), workload average/day (positive), social smoking (negative), and weight 
                  (negative). We also see strong correlations with age (positive), social drinking (positive), height
                  (positive), and BMI (negative).
                  
                  <br/><br/>
                  
                  Despite these correlations, it is hard to say whether or not many of these variables 
                  actually cause absenteeism. While some may have strong correlation, it isn't necessarily
                  a direct cause. After all, BMI has a strong negative correlation, and social smoking has a slight
                  negative correlation, which may be the opposite of what people are expecting. While these do provide
                  accurate correlations, further research must be conducted in order to determine causation.
                  
                  "),
                   
                   
                  
                ),
                mainPanel(
                  selectInput("health_factor", label = "Select a Health Factor",
                              choices = c("Service_time", "Age", "Work_load_Average.day", 
                                          "Social.drinker", "Social.smoker", "Weight", 
                                          "Height", "Body_mass_index")),
                  checkboxInput("add_trendline", "Add Trendline", FALSE),
                  tabsetPanel(
                    tabPanel("Plots", plotOutput("health_plot", height = "500px", width = "800px")),
                    tabPanel("Average Time Off", plotOutput("avg_time_plot", height = "500px", width = "800px"))
                  )
                )
              )),
      
      tabPanel("Conclusion",
               sidebarLayout(
                 sidebarPanel(HTML("From the analysis that we have done on the data set, we concluded
                                   in the end that there was no substantial evidence to suggest that 
                                   there is any pattern between any of the factors we chose and absenteeism."),
                              
                              tags$hr(),
                              HTML("<ul>
                                    <li><b>Question 1</b>: The plots show that there is a weak positive relationship
                                      between distance to work and absences. As for transportation expenses
                                      and absences, there is a weak negative correlation. It’s also worth noting
                                      that the correlation’s direction changes depending on the range of data being
                                      observed for the transportation expense variable. <br/><br/>
                                      
                                      Many of the data points for both variables do not fall near the line of best fit. 
                                      Thus, we can not conclude that there is a relationship between total absences and
                                      the variables mentioned above. </li>
                                    </ul>"),
                              
                                  tags$hr(),
                                  HTML("<ul>
                                      <li><b>Question 2</b>: What the data seems to indicate is that social factors have very
                                      little impact on the number of absences that an employee has. For example, the number
                                      of absences comes more from individuals who have no children or pets and one can see
                                      a general decrease in absences as an employee has more pets or children. <br/><br/>
                                      
                                      It's also difficult to determine whether or not education plays a huge role in the number
                                      of absences because a massive majority of employees are only high school graduates, thus skewing
                                      the data to include them the most. </li>
                                      </ul>"),
                              
                                  tags$hr(),
                                  HTML("<ul>
                                      <li><b>Question 3</b>: Many of the variables do not have any correlation when plotted versus total number
                                      of absence hours. The few variables that we found have a correlation was height (positive) and BMI (negative).
                                      However, when comparing versus average time off, we see that there are slight correlations for service time (positive),
                                      workload average/day (positive), social smoking (negative), and weight (negative). We also see strong correlations with
                                      age (positive), social drinking (positive), height (positive), and BMI (negative). <br/><br/>
                                      
                                      Despite these correlations, it is hard to say whether or not many of these variables actually cause absenteeism. 
                                      While some may have strong correlation, it isn't necessarily a direct cause. After all, BMI has a strong negative correlation,
                                      and social smoking has a slight negative correlation, which may be the opposite of what people are expecting. So while these
                                      do provide accurate correlations, further research must be conducted in order to determine causation.</li>
                                   </ul>")),
                 mainPanel()
               ))
    )
)


server <- function(input, output) {
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
