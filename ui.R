fluidPage(
  # add header
  headerPanel(
    h1(strong("OkCupid User Demographics and User Engagement")),
  ),
  br(),
  br(),
  # add widgets
  fluidRow(style = 'padding-left: 3px',
           column(5, 
                  tabsetPanel(
                    # add bubble map
                    tabPanel(h4("Map"), 
                             br(),
                             h4('OkCupid users within a 25-mile radius of San Francisco, CA'),
                             leafletOutput('okcmap', height = 700),
                             br(),
                             h4('(Circle sizes correspond to number of users)')
                    ),
                    # add data info
                    tabPanel(h4("About This Data"), style = 'padding-top: 3px',
                             br(),
                             h4(about_data)
                    )
                  ),
           ),
           column(7, 
                  tabsetPanel(
                    # add demographics analysis
                    tabPanel(h4("Demographics"), style = 'padding-left: px',
                             fluidRow(
                               br(),
                               column(3,
                                      selectInput(inputId = 'dem_options',
                                                  label = 'Break down data by',
                                                  choices = c('age','sex','status','orientation'))),
                               column(3,
                                      selectInput(inputId = 'dem_options_2',
                                                  label = 'and by ...',
                                                  choices = c('age','sex','status','orientation'),
                                                  selected = 'sex'))
                             ),
                             fluidRow(
                               textOutput(outputId = 'dem_title_1'),
                               plotOutput(outputId = 'dem_plot_1', width = '75%'),
                               br(),
                               textOutput(outputId = 'dem_title_2'),
                               plotOutput(outputId = 'dem_plot_2', width = '75%'),
                             )
                    ),
                    # add two tabs of engagement analysis
                    tabPanel(h4('User Engagement'),
                             br(),
                             tabsetPanel(
                               tabPanel('Activeness',
                                        br(),
                                        h4('User Count by Activness (very active: logged in within last 3 days; active: within last 30 days; inactive: away > 30 days)'),
                                        plotOutput(outputId = 'active_1', height = 300, width = 600),
                                        fluidRow(
                                          column(width = 5,
                                                 selectInput(inputId = 'dem_options_3',
                                                             label = h4('See Activeness by'),
                                                             choices = c('age','sex','status','orientation')),
                                                 plotOutput(outputId = 'active_2', width = '750')
                                          ),
                                          # will work on this later....
                                          column(width = 2,
                                                 tableOutput('active_chi_Sq')
                                          )
                                        )
                               ),
                               tabPanel('Profile Completion', 
                                        h4('Profile Questions Completion by Percent of Users'),
                                        plotOutput(outputId = 'prof_compl_1', width = '75%'),
                                        
                                        column(7,
                                          selectInput(inputId = 'dem_options_4',
                                                      label = h4('See Avg # of Profile Questions Answered by'),
                                                      choices = c('age','sex','status','orientation')),
                                          plotOutput(outputId = 'prof_compl_2', height = 300)
                                        )
                               )
                             ),
                    ),
                    # add data table
                    tabPanel(h4("Data Table"), style='padding-top:3px; padding-right:1px;',
                             fluidRow(
                               br(),
                               column(7,
                                      dataTableOutput(outputId = 'datatable'), width = 7
                               )
                             )
                    ),
                    # add my info
                    tabPanel(h4("About Author"),
                             fluidRow(
                               column(7, 
                                      h2("Yi Cao"),
                                      h4('Summary under construction'),
                                      br(),
                                      h4("My Email: yicao.corcordium@gmail.com"),
                                      tags$a(href="https://linkedin.com/in/yi-cao-58048695", 
                                             h4("My LinkedIn")),
                                      tags$a(href="https://github.com/dynacao", 
                                             h4("My GitHub")),
                               )
                             )
                    )
                  ))
  )
)