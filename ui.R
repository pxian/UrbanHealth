#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
shinyUI(
  dashboardPage(skin = "black",
    dashboardHeader(title="Urban Health"),
    dashboardSidebar(
      sidebarMenu(id= "menutab",
                  menuItem("Homepage",tabName = "homepage",icon = icon("th",lib='glyphicon')),
                  h4("Urban Health Index"),
                  conditionalPanel("input.menutab === 'homepage'",
                  
                  sliderInput("year_slider", "Select year",
                              min = 1950, max = 2050, value = 1950, step = 10
                  )),
                  
                  menuItem("Tobacco Consumption", tabName = "tobacco", icon=icon("ban-circle",lib='glyphicon')),
                  conditionalPanel("input.menutab === 'tobacco'",
                                   
                                   selectInput(
                                     "year_input",
                                     width = "100%",
                                     label = h3("Select year:"),
                                     choice = c("1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010"
                                                ,"2011","2012","2013")
                  )),                                    
                  menuItem("Overweight Children",tabName = "overweight",icon =icon("signal",lib = 'glyphicon')),
                  conditionalPanel("input.menutab === 'overweight'"
                                   ),
                                    
                  menuItem("About",tabName = "about",icon = icon("user",lib = "glyphicon"))
                  
      
    )
    ),
    dashboardBody(
      tabItems(
        tabItem("homepage",
                tabsetPanel(
                  type ="tabs",
                  tabPanel("Urban Population by Country",
                           p(""),
                           h3("Urban Population. Hover your mouse on the map, the country name and its urban population will appear."),
                           p(""),
                           
                           htmlOutput("world_map_plot", width ="100%", height = 650)
                  ),
                  
                  tabPanel("UHI by Year",
                           p(""),
                           h3("The countries will appear in the word cloud based on the selected year. 
                              The size of the word indicates the urban population index."),
                           p(""),
         
                           box(title ="Word Cloud",
                               solidHeader = TRUE,
                               collapsible = TRUE,
                               plotOutput(
                                 "population_country_cloud",
                                 width = "100%",
                                 height = 650
                               ))
                  ),
                  tabPanel("UHI Data Table",
                           p(""),
                           fluidRow(title = "UHI data table",
                                    box(
                                      title = "UHI data table in selected year",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      DT::dataTableOutput(
                                        "population_of_one_country_data_table",
                                        width = "100%",
                                        height = 500
                                      )
                                    )
                           )
                  )
                )
                
        ),#homepage end
        
        tabItem("tobacco",
                h3("Percentage of tobacco consumption from 1999 to 2013:"),
                  tabPanel("Tobacco consumption Table",
                           p(""),
                           radioButtons("gender_input", "Gender",
                                              choices = c("Male",
                                                          "Female"),
                                              selected = "Male"),
                           fluidRow(title = "Tobacco consumption Table",
                                    box(
                                      title = "Tobacco consumption table in selected year",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      tableOutput(
                                        "tobacco_table"
                                      )
                                    )
                           )
                  )
                
        ),#tobacco end
        
        tabItem("overweight",
            h3("Percentage of overweight children:"),
            plotOutput(
            "histogram",
             width = "100%",
             height = 1000
           )
        ),#overweight end
       
        tabItem("about",
              
                h3("The team"),
                p("WIE170046 - YAU PEI CHI"),
                p("WIE170024 - LIM PHOOI XIAN"),
                p("WIE170016 - GOO MEI CHING"),
                p(""),
                p(""),
                h3("About this project"),
                p("This project aim to assist WHO to discover urban health of the regions."),
                p("The 2 key factors will be investigated."),
                p("1) Tobacco consumption"),
                p("2) Overweight children"),
                p(""),
                p(""),
                #h4("show data"),
                #DT::dataTableOutput("mytable")
                h3("Sources for this project"),
                a(href="http://apps.who.int/gho/data/node.main.nURBPOP?lang=en","Urban Population"),
                br(),
                a(href="http://apps.who.int/gho/data/node.main.n271?lang=en","Tobacco consumption"),
                br(),
                a(href="http://apps.who.int/gho/data/node.main.nEQOVERWEIGHT?lang=en","Overweight children")
                
        )#about end
      )
    )
  )
)

