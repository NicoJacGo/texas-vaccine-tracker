library(shiny)
library(leaflet)
library(leaflet.extras)
library(tidyverse)
library(shinythemes)

shinyServer( 
  function(input, output) {
    tx_data <- read_csv("new_aggregate.csv")
    #data.frame(test2)
    tx_data <- data.frame(tx_data)
    colnames(tx_data)
    colnames(tx_data)[colnames(tx_data) == 'lat'] <- 'Latitude'
    colnames(tx_data)[colnames(tx_data) == 'lon'] <- 'Longitude' 
    colnames(tx_data)
    tx_data$Latitude <- as.numeric(tx_data$Latitude)
    tx_data$Longitude <- as.numeric(tx_data$Longitude)
    tx_data = filter(tx_data, Latitude != "NA")
    pal <- colorFactor(pal = c("#1b9e77", "#d95f02", "#7570b3"), domain = c("Charity", "Government", "Private"))
    tx_data <- mutate(tx_data, cntnt=paste0('<strong>Provider Name: </strong>',Provider_Name,
                                            '<br><strong>Address:</strong> ', Address,
                                            '<br><strong>City:</strong> ', City,
                                            '<br><strong>County:</strong> ',County,
                                            '<br><strong>Doses (Week 5):</strong> ',Doses_W5,
                                            '<br><strong>Total:</strong> ',Sum)) 
    output$mymap <- renderLeaflet({
      leaflet(tx_data) %>%
        leaflet.extras::addSearchOSM(options = searchOptions(collapsed = TRUE)) %>%
        addTiles() %>%
        addCircleMarkers(data = tx_data, lat =  ~Latitude, lng =~Longitude, 
                         radius = 7.5, popup = ~as.character(cntnt), clusterOptions = markerClusterOptions(),
                         color = "red",
                         stroke = FALSE, fillOpacity = 0.8)%>%
        addLegend(pal=pal, values=tx_data$SumDosesRecd,opacity=1, na.label = "Not Available")%>%
        addEasyButton(easyButton(
          icon="fa-crosshairs", title="ME",
          onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
      
      
      
    })
    output$txtout <- renderText({
      paste( input$txt1, input$txt2, sep = " " )
    })
    
    output$downloadCsv <- downloadHandler(
      filename = function() {
        paste("COVID_Vaccine_Data_TX.csv", sep="")
      },
      content = function(file) {
        tx_data_sub = tx_data %>% dplyr::select(c(Provider_Name, Address, City, County, Doses_W1, Doses_W2, Doses_W3,
                                                  Doses_W4, Doses_W5, Sum))
        names(tx_data_sub) = c("Provider", "Address", "City", "County", "Doses_W1","Doses_W2","Doses_W3", "Doses_W4", 
                               "Doses_W5", "Total" )
        write.csv(tx_data_sub, file)
      }
    )
    
    output$rawtable <- renderPrint({
      tx_data_sub = tx_data %>% dplyr::select(c(Provider_Name, Address, City, County, Doses_W1, Doses_W2, Doses_W3,
                                                Doses_W4, Doses_W5, Sum))
      names(tx_data_sub) = c("Provider", "Address", "City", "County", "Doses_W1","Doses_W2","Doses_W3", "Doses_W4", 
                             "Doses_W5", "Total" )
      orig <- options(width = 1000)
      print(tail(tx_data_sub, input$maxrows), row.names = FALSE)
      options(orig)
    })
  
} )