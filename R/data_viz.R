#library(tidytext)
#library(tidyverse)
#library(ggplot2)
#library(wordcloud)
#library(reshape2)
#library(igraph)
#library(ggraph)

#' Plot Top 10 words of a song
#'
#' Plots the Top 10 most frequent words in a lyrics
#'
#' @param tokens_single_no_stop A tidytext dataframe without stopwords
#'
#'
#' @examples
#'
#' @export
viz_top_10_words<-function(tokens_single_no_stop){
tokens_single_no_stop %>%
  count(word, sort = TRUE) %>%
  top_n(10)%>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
}

#' Plot sentiment of a song by artist
#'
#' Plots the sentiment for each artist featured in the song
#'
#' @param lyric_sentiment A tidytext dataframe without stopwords and joined with a sentiment database
#'
#'
#' @examples
#'
#' @export
viz_sentiment_by_artist<-function(lyric_sentiment){
  ggplot(lyric_sentiment, aes(index, sentiment, fill = artist_name)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~artist_name, ncol = 2, scales = "free_x")
}

#' Plot Top 10 words that contribute to positive/negative sentiment of a song
#'
#' Plots the Top 10 words that contribute to positive/negative sentiment of a song
#'
#' @param bing_word_counts A tidytext dataframe without stopwords and joined with a sentiment database
#'
#'
#' @examples
#'
#' @export
viz_sentiment_word_contrib<-function(bing_word_counts){
  bing_word_counts %>%
    group_by(sentiment) %>%
    top_n(10) %>%
    ungroup() %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = sentiment)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~sentiment, scales = "free_y") +
    labs(y = "Contribution to sentiment",
         x = NULL) +
    coord_flip()

}

#' Plot comparative wordcloud for sentiment of words that contribute to positive/negative sentiment of a song
#'
#' Plot comparative wordcloud that shows contribute to positive/negative sentiment of a song
#'
#' @param bing_word_counts A tidytext dataframe without stopwords
#'
#'
#' @examples
#'
#' @export
viz_sentiment_wordcloud<-function(tokens_single_no_stop){
  tokens_single_no_stop %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, sentiment, sort = TRUE) %>%
    acast(word ~ sentiment, value.var = "n", fill = 0) %>%
    comparison.cloud(colors = c("red", "green"),
                     max.words = 100,main='Major contributions to sentiment')

}

#' Plot graph of bigrams of a lyrics
#'
#' Plots graph of relationship between words, in bigrams,  of a lyrics
#'
#' @param bing_word_counts A tidytext dataframe without stopwords and organized in bigrams
#'
#'
#' @examples
#'
#' @export
visualize_bigrams <- function(bigrams) {
  set.seed(2020)
  a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

  bigrams %>%
    graph_from_data_frame() %>%
    ggraph(layout = "fr") +
    geom_edge_link(aes(edge_alpha = n), show.legend = TRUE, arrow = a) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
    theme(plot.title = element_text(colour = alpha('black'), "Bigrams relationships of lyrics"))
}

#' Plot comparative wordcloud for 2-topic LDA
#'
#' Plot comparative wordcloud that shows contribute to 2-topic Latent Dirichlet Allocation
#'
#' @param ap_top_terms A tidytext beta dataframe already filtered
#'
#'
#' @examples
#'
#' @export
viz_lda_wordcloud<-function(ap_top_terms){
  ap_top_terms %>%
    mutate(topic = paste("topic", topic)) %>%
    acast(term ~ topic, value.var = "beta", fill = 0) %>%
    comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                     max.words = 100,main='Topic contribution for 2-topic LDA')


}
