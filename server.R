library(dplyr)
library(plotly)
library(shiny)
library(shinyWidgets)

start_date <- as.Date("2017-04-01")
end_date <- as.Date("2019-07-31")

# reading data
data <- read.csv("sales.csv", sep = ";", dec = ".", 
                 header = T, fileEncoding = "cp1251",
                 stringsAsFactors = F,
                 colClasses = c("factor", "Date", "integer", 
                                "numeric", rep("factor", 2)))

# filters applied to subset data
shops <- unique(data$shop)
start_date <- min(data$date)
end_date <- max(data$date)
print(shops)

server <- function(input, output, session) {
 
        # chosen dates range 
        # output$dateRangeText <- renderText({ paste(as.character(input$dateRange)) })
        

        # chosen shops
        output$text_choice1 <- renderPrint({ return(input$checkGroup1) })

        output$results <- renderTable({
                print(input$checkGroup1)
                start_date <- input$dateRange[1]
                end_date <- input$dateRange[2]
                shops <- input$checkGroup1
                
        })
        
        output$plot <- renderPlotly({
                print(input$checkGroup1)
                start_date <- input$dateRange[1]
                end_date <- input$dateRange[2]
                shops <- input$checkGroup1
                
                subset_data <- data %>% 
                        filter(shop %in% shops,
                               between(date, start_date, end_date)) %>% 
                        group_by(shop, month) %>% 
                        summarise(sales = sum(sales)) %>% droplevels
                     
                
                colnames(subset_data)[2] <- "time"
                plot_ly(subset_data, 
                                   x = ~time, y = ~sales, 
                                   color = ~shop, 
                                   type = "scatter", mode = "lines") %>% 
                        layout(title = "Monthly sales, Russian Rubles")
                
        })
        

}
