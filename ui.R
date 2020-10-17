fluidPage(
  tags$head(
    'What is this?'
  ),
  
  # Header
  headerPanel(
    "this is temporary header"
  ),
  
  
  # Input widgets
  fluidRow(
    column(5,
           conditionalPanel(condition="input.plot_tabs!='User guide'",
                            tabsetPanel(id="ui_tab",
                                        tabPanel("Map",
                                                 'Placeholder'
                                        ),
                                        tabPanel("Table",
                                                 'Placeholder'
                                                 #column(12, h4("Click a site"), div(DT::dataTableOutput("table_input"), style = "font-size:70%"))
                                        )
                            )
           ),
           conditionalPanel(condition="input.plot_tabs=='User guide'",
                            column(12)
           )
    ),
    column(7,
           tabsetPanel(id="plot_tabs",
                       
                       tabPanel("Demographics",
                                fluidRow(
                                  'Placeholder'
                                )
                       ),
                       tabPanel("User Engagement",
                                fluidRow(
                                  column(4, uiOutput("date_select"))
                                ),
                                fluidRow(
                                  column(4, 'placeholder'),
                                  column(8, 'placeholder')
                                )
                       ),
                       tabPanel("About Data",
                                fluidRow(
                                  column(8,
                                         'Placeholder'
                                  )
                                )
                       ),
                       tabPanel("About Author",
                                fluidRow(
                                  column(8,
                                         'Placeholder'
                                  )
                                )
                       )
           ))
  )
)