#require(shiny)

ui <- fluidPage(
  titlePanel("Gentiment"),
  sidebarLayout(
    sidebarPanel(
      actionButton("action", "Action"),
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
