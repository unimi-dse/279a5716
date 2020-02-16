#require(shiny)
#require(gridExtra)
#source('data_acquisition.R')
#source('data_analysis.R')
#source('data_viz.R')



app_server <- function(input, output) {
  Sys.setenv(GENIUS_API_TOKEN = '93UQJDr8DuqNJO5O23cKwdmo9BI1xqYQJrIB6iYEy21-toFaDOt_PxKr9kfM7T9s')
  
  Sys.setenv(SPOTIFY_CLIENT_ID = '74436a745c24482b90025891795a660b')
  Sys.setenv(SPOTIFY_CLIENT_SECRET = 'dc93d19fc41f46d4b6c8cd4c2068eda0')
  #list.of.packages <- c("ggplot2", "Rcpp","data.table","shiny","geniusr","spotifyr","tidytext","tidyverse","topicmodels","wordcloud","reshape2","igraph","ggraph")
  #new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  #if(length(new.packages)) install.packages(new.packages)
  event_catch <- eventReactive(input$action, {
    #runif(input$n)
    current_song<-get_my_current_play()
    search_now<-get_artist_songs_in_df(current_song[2])
    lyrics<-get_lyric_from_song(current_song[1],search_now)
    if(is.null(lyrics)){
      showModal(modalDialog(
        title = "Song not Found",
        paste0("It seems that this song is not on Genius. Try when you are listening a song that's on Genius"),
        easyClose = TRUE,
        footer = NULL
      ))
    }
    return(list(lyrics,current_song))
  })
  output$sentimentPlot <- renderPlot({
    lyrics_tokens<-tokenize_lyrics(event_catch()[[1]])
    lyrics_tokens_clean<-tokenize_lyrics_clean_stopwords(lyrics_tokens)
    lyrics_sentiment<-sentiment_lyrics(lyrics_tokens_clean)
    viz_sentiment_by_artist(lyrics_sentiment)
  })

  output$sentimentwcPlot <- renderPlot({
    lyrics_tokens<-tokenize_lyrics(event_catch()[[1]])
    lyrics_tokens_clean<-tokenize_lyrics_clean_stopwords(lyrics_tokens)
    par(mar = rep(0, 4))
    viz_sentiment_wordcloud(lyrics_tokens_clean)
    title('Major contributions to sentiment',line=-0.8)
  })

  output$bigramPlot <- renderPlot({
    lyrics_bigrams<-count_bigrams(event_catch()[[1]])
    visualize_bigrams(lyrics_bigrams)
    #title('Bigrams of lyrics',line=-0.8)
  })

  output$LDAPlot <- renderPlot({
    lyrics_tokens<-tokenize_lyrics(event_catch()[[1]])
    lyrics_tokens_clean<-tokenize_lyrics_clean_stopwords(lyrics_tokens)
    lyrics_lda_top<-make_lda_lyrics(lyrics_tokens_clean)
    par(mar = rep(0, 4))
    viz_lda_wordcloud(lyrics_lda_top)
    title('Topic contribution for 2-topics LDA',line=-0.8)
  })

  output$albumCover<-renderText({c('<img src="',event_catch()[[2]][4],'">')})

  output$songTitle<-renderText({paste('Song Title: ',event_catch()[[2]][1])})

  output$artist<-renderText({paste('Song Artist: ',event_catch()[[2]][2])})

  output$albumTitle<-renderText({paste('Album Title: ',event_catch()[[2]][3])})

  output$Lyrics <- renderTable(event_catch()[[1]]$line,caption = "Lyrics",
                               caption.placement = getOption("xtable.caption.placement", "top"),
                               caption.width = getOption("xtable.caption.width", NULL))
}


