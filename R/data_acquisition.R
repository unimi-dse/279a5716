#require(data.table)
#require(geniusr)
#require(spotifyr)
#require(attempt)


#' Retrieve songs of artist
#'
#' Searches and gets all songs of a specified artist
#'
#' @param artist_query the string containing the artist name
#'
#' @return A dataframe with all the songs of an artist and other infos(like song_id)
#'
#' @examples
#'
#' @export


get_artist_songs_in_df <- function(artist_query){
  artist_query_res <- search_artist(artist_query)
  matching<-pmatch(artist_query,artist_query_res$artist_name)
  artist_genius_id <- artist_query_res$artist_id[matching]
  artist_df<-get_artist_df(artist_genius_id)
  artist_songs_df <- get_artist_songs_df(artist_genius_id)
  return(artist_songs_df)
}

#' Retrieve lyrics of multiple songs
#'
#' gets lyrics from a dataframe of songs
#'
#' @param songs_df A dataframe with songs names and songs Genius ids
#'
#' @return A list of dataframes with all the lyrics of the songs. Each row of the dataframe is a line
#'
#' @examples
#'
#' @export
get_lyrics_from_songs_df <- function(songs_df){
  songs_name_vec<-as.vector(songs_df$song_name)
  lyrics_complete<-lapply(songs_name_vec,get_lyric_from_song,songs_df=songs_df)
  clean_lyrics_complete<-Filter(Negate(is.null),lyrics_complete)
  return(rbindlist(clean_lyrics_complete))
}
#' Retrieve lyrics of a song
#'
#' gets lyric given a song and a songs dataframe (that includes Genius song id)
#'
#' @param song_name A string with the song name
#' @param songs_df A dataframe with songs names and songs Genius ids
#'
#' @return A dataframe with all the lyric of the song. Each row of the dataframe is a line
#'
#' @examples
#'
#' @export
get_lyric_from_song<-function(song_name,songs_df)
{
  matching<-pmatch(song_name,songs_df$song_name)
  matching_id_char<-as.character(songs_df$song_id[matching])
  return(tryCatch(get_lyrics_id(matching_id_char), error=function(e) NULL))
}
#' Retrieve currently playing song on Spotify
#'
#' gets the currently playing song on Spotify
#'
#'
#' @return An array of various information about the currently playing song
#'
#' @examples
#'
#' @export
get_my_current_play<-function(){
  now_playing<-get_my_currently_playing()
  return(c(now_playing$item$name,now_playing$item$artists$name,now_playing$item$album$name,now_playing$item$album$images$url[2]))
}

