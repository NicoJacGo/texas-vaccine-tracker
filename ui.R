library(shiny)
library(readr)
library(leaflet)
library(leaflet.extras)
library(shinythemes)
library(dplyr)
tx_data_g = read_csv("new_aggregate.csv")

shinyUI(bootstrapPage(
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             HTML('<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#">Texas Vaccine Tracker</a>'), id="nav",
             windowTitle = "COVID-19 Vaccine Tracker",
             tabPanel("Map",
                      div(class="outer",
                          tags$head(includeCSS("styles.css")),
                          leafletOutput("mymap", width="100%", height="100%"),
                          
                          absolutePanel(id = "logo", class = "card", bottom = 20, left = 20, width = 30, fixed=TRUE, draggable = FALSE, height = "auto",
                                        actionButton("twitter_share", label = "", icon = icon("twitter"),style='padding:5px',
                                                     onclick = sprintf("window.open('%s')", 
                                                                       "https://twitter.com/intent/tweet?text=%20Texas-Vaccine-Tracker%20mapper&url=https://bit.ly/2uBvnds&hashtags=coronavirus")))
                          
                          
                      )
             ),
             navbarMenu(title = "County Analysis",
                        tags$a("UNDER CONSTRUCTION"),
                        tabPanel(title = a("Bins")), tabPanel(title = a("Trends")), tabPanel(title = a("Projections"))
                        
                        
                        
             ),
             
             tabPanel("Data",
                      numericInput("maxrows", "Rows to show", 25),
                      verbatimTextOutput("rawtable"),
                      downloadButton("downloadCsv", "Download as CSV"),tags$br(),tags$br(),
                      "Adapted from data published by the", tags$a(href="https://www.dshs.texas.gov/coronavirus/immunize/vaccine.aspx", 
                                                                   "Texas Health and Human Services.")
             ),
             tabPanel("About",
                      tags$div(
                        tags$h4("Last update"), 
                        #h6(paste0(update)),
                        "This site is updated once a week. There are several other excellent vaccine tracking tools available, including those run by", 
                        tags$a(href="https://www.bloomberg.com/graphics/covid-vaccine-tracker-global-distribution/", "Bloomberg"),
                        
                        "Our aim is to complement these resources with several interactive features as well as visualization of data detailing pharmacy locations vaccine dosage allotments.",
                        
                        tags$br(),tags$br(),tags$h4("Background"), 
                        "We intend on making this web application available to the general populace, giving them the ability to easily locate the nearest location offering vaccines, with the given weekly vaccine allotment and previous weekly data, along with aggregate weekly allotment data.
                          This dataset was created to give users the ability to examine Texas' COVID vaccine allotment progress, which is an ongoing process. The data will be updated on a weekly basis, and aggregated in the aggregate.csv file. New data is provided once weekly, on Tuesday, by the Texas DSHS and converted from PDF to .csv",
                        tags$br(),tags$br(),
                        "This dataset was created to give users the ability to examine Texas' COVID vaccine allotment progress, which is an ongoing process. The data will be updated on a weekly basis, and aggregated in the *aggregate.csv* file. Data is aggregated from data published by the Texas DSHS. 
                          The raw data, published in .pdf format, is available from the raw folder.",
                        tags$br(),tags$br(),
                        tags$br(),tags$br(),tags$h4("Sources"),
                        tags$b("Texas vaccination statistics"), tags$a(href="https://tabexternal.dshs.texas.gov/t/THD/views/COVID-19VaccineinTexasDashboard/Summary?%3Aorigin=card_share_link&%3Aembed=y&%3AisGuestRedirectFromVizportal=y", "the Texas DSHS homepage"),
                        tags$b("weekly vaccine allocation reports: "), tags$a(href="https://www.dshs.texas.gov/coronavirus/immunize/vaccine.aspx", "the Texas DSHS"),
                        tags$br(),tags$br(),tags$h4("Authors"),
                        "Nicolas Jacobs, University of Toronto",tags$br(),
                        "Hanad Hassan, University of Toronto",tags$br(),
                        tags$br(),tags$br(),tags$h4("Contact"),
                        tags$a(href="https://www.nicojacgo.com", "Nicolas Jacobs"),tags$br(),tags$br(),
                        tags$a(href="https://www.hanadhassan.com", "Hanad Hassan"),tags$br(),tags$br(),
                        
                        
                      )
             )
  )
))

