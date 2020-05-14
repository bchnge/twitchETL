#' Title
#'
#' @param clientID Twitch API client key (str)
#' @param game_id
#'
#' @return a dataframe of recent streams for given game id
#' @export
#'
#' @examples

getCurrentStreams <- function(clientID, game_id){
  h <- curl::new_handle()
  curl::handle_setopt(h, verbose = TRUE)
  curl::handle_setheaders(h, .list = list(
    'Accept' = 'application/json',
    'Client-ID' = clientID,
    'Authorization' = paste0('Bearer ', access_token))
  )

  req = curl::curl_fetch_memory(paste0('https://api.twitch.tv/helix/streams?game_id=', game_id,'&first=100'),
                                handle = h)
  streams <- req$content %>% rawToChar %>% jsonlite::parse_json()
  stream_data <- lapply(streams$data,
                        function(x) as.data.frame(x) %>%
                          dplyr::select(id, user_id, user_name, game_id, type, title, viewer_count, started_at, language)) %>%
    dplyr::bind_rows()
  #stream_data <- lapply(streams$data, function(x) x)
  return(stream_data)
}
