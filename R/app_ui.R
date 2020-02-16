require(shiny)

app_ui <- fluidPage(
  titlePanel("musicdashboaRd2"),
  sidebarLayout(
    sidebarPanel(
      actionButton("action", "Get currently playing song"),
      htmlOutput("albumCover"),
      textOutput("songTitle"),
      textOutput("artist"),
      textOutput("albumTitle"),
      tableOutput("Lyrics")
    ),
    mainPanel(plotOutput("sentimentPlot"),
              plotOutput("bigramPlot"),
              fluidRow(column(width=6,plotOutput("sentimentwcPlot")),
                       column(width=6,plotOutput("LDAPlot"))
                       )
              )
    )
  )
