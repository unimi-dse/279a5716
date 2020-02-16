#library(tidytext)
#library(tidyverse)
#library(topicmodels)

#' Lyrics tokenizer
#'
#' Tokenize lyrics in unigrams
#'
#' @param single_lyric a dataframe with the lyrics
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
tokenize_lyrics<-function(single_lyric){
  tokens_single<-single_lyric %>%
    unnest_tokens(word, line)
  return(tokens_single)

}

#' Lyrics Stopwords cleaner
#'
#' Delete stopwords from unigrams tidytext dataframe
#'
#' @param tokens_single A tidytext dataframe already made of unigrams
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
tokenize_lyrics_clean_stopwords<-function(tokens_single){
  data(stop_words)
  tokens_single_no_stop <- tokens_single %>%
    anti_join(stop_words)
  return(tokens_single_no_stop)
}


#' Lyrics sentiment joiner
#'
#' Joins to the tidytext unigrams dataframe the value of the sentiment (bing database)
#'
#' @param tokens_single_no_stop A tidytext dataframe already made of unigrams and clean from stopwords
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
sentiment_lyrics<-function(tokens_single_no_stop){
  lyric_sentiment <- tokens_single_no_stop %>%
    inner_join(get_sentiments("bing")) %>%
    count(artist_name,index=row_number() ,sentiment) %>%
    spread(sentiment, n, fill = 0) %>%
    mutate(sentiment = positive - negative)
}


#' Lyrics sentiment joiner
#'
#' Joins to the tidytext unigrams dataframe the value of the sentiment (bing database) and group by words
#'
#' @param tokens_single_no_stop A tidytext dataframe already made of unigrams and clean from stopwords
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
sentiment_lyrics_count<-function(tokens_single_no_stop){
  bing_word_counts <- tokens_single_no_stop %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, sentiment, sort = TRUE) %>%
    ungroup()
}

#' Bigrams dataframe tokenizer
#'
#' Tokenize lyrics in bigrams and group by the bigrams.
#'
#' @param dataset a dataframe with the lyrics
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
count_bigrams <- function(dataset) {
  dataset %>%
    unnest_tokens(bigram, line, token = "ngrams", n = 2) %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% stop_words$word,
           !word2 %in% stop_words$word) %>%
    count(word1, word2, sort = TRUE)
}

#' 2-topic LDA for lyrics
#'
#' Makes the Latent Dirichlet allocation for the specified lyric
#'
#' @param tokens_single_clean A tidytext dataframe already made of unigrams and clean from stopwords
#'
#' @return A tidytext dataframe
#' @examples
#'
#' @export
make_lda_lyrics<-function(lyrics_tokens_clean){
  lyrics_tokens_clean_dtm<- lyrics_tokens_clean %>%
    count(artist_name, word)%>%
    cast_dtm(artist_name,word,n)

  ap_lda <- LDA(lyrics_tokens_clean_dtm, k = 2, control = list(seed = 2020))
  ap_topics <- tidy(ap_lda, matrix = "beta")

  ap_top_terms <- ap_topics %>%
    group_by(topic) %>%
    top_n(50, beta) %>%
    ungroup() %>%
    arrange(topic, -beta)
  return(ap_top_terms)

}
