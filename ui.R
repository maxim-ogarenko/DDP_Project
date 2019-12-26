library(shiny)
library(shinyWidgets)
library(plotly)

start_date <- as.Date("2017-04-01")
end_date <- as.Date("2019-07-31")

#Preparing DF
data <- read.csv("sales.csv", sep = ";", dec = ".", 
                 header = T, fileEncoding = "cp1251",
                 stringsAsFactors = F,
                 colClasses = c("factor", "Date", "integer", 
                                "numeric", rep("factor", 2)))

ui <- fluidPage(
        titlePanel("Choose dates range to analyze sales"),
        helpText("DD/MM/YY"),
        dateRangeInput(
                'dateRange',
                label = 'Date range input',
                start = start_date,
                end = end_date,
                min = start_date,
                max = end_date,
                format = "dd/mm/yy",
                startview = 'year',
                weekstart = 1
        ),
        
        verbatimTextOutput("dateRangeText"),
        
        titlePanel("Choose shops to analyze sales"),
        helpText("one, two or all three"),

        
        pickerInput(
                "checkGroup1",
                "Shops",
                levels(data$shop),
                selected = levels(data$shop),
                options = list(`actions-box` = TRUE),
                multiple = T
        ) ,
        
        fluidRow(column(3, verbatimTextOutput("text_choice2"))),
        plotlyOutput("plot")
        
)