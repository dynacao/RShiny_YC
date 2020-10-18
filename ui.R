fluidPage(
  # add header
  headerPanel(
    h1("OkCupid User Demographics and User Engagement")
  ),
  br(),
  br(),
  # add widgets
  fluidRow(
    column(5, 
           tabsetPanel(id="ui_tab",
                       tabPanel(h4("Map"), 
                                br(),
                                h4('OkCupid users within a 25-mile radius of San Francisco, CA'),
                                leafletOutput('okcmap', height = 700),
                                br()
                       ),
                       tabPanel(h4("About This Data"), style = 'padding-top: 3px',
                                br(),
                                h4(about_data),
                       )
           ),
    ),
    column(7, 
           tabsetPanel(
             # add demographics analysis
             tabPanel(h4("Demographics"), style = 'padding-left: 3px',
                      fluidRow(
                        column(3,
                               selectizeInput(inputId = 'dem_bd_1', 
                                              label = 'See data broken down by',
                                              choices = dem_options)),
                        br(),
                        plotOutput(outputId = 'dem_plot')
                        
                      )),
             # add two tabs of engagement analysis
             tabPanel(h4('User Engagement'),
                      br(),
                      tabsetPanel(id = 'us_tab',
                                  tabPanel('Activeness',
                                           selectInput(inputId = 'act', 
                                                       label = 'Select Item to Display',
                                                       choices = dem_options,
                                                       selected = 'age',
                                                       selectize = F),
                                           br(),
                                           plotOutput(outputId = 'active_1')
                                  ),
                                  
                                  tabPanel('Profile Completion', 
                                           br(),
                                           plotOutput(outputId = 'prof_compl_1'))
                      ),
             ),
             # add data table
             tabPanel(h4("Data Table"), style='padding-top:3px; padding-right:1px;',
                      fluidRow(
                        br(),
                        column(7,
                               box(dataTableOutput(outputId = 'datatable'), width = 8)
                        )
                      )
             ),
             # add my info
             tabPanel(h4("About Author"),
                      fluidRow(
                        column(8,
                               h4('Currently under construction')
                        )
                      )
             )
           ))
  )
)