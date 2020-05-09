#' Title
#'
#' @param clientID
#' @param game_id
#'
#' @return
#' @export
#'
#' @examples
getCurrentStreams <- function(clientID, game_id){
  h <- curl::new_handle()
  curl::handle_setopt(h, verbose = TRUE)
  curl::handle_setheaders(h, .list = list(
    'Accept' = 'application/json',
    'Client-ID' = clientID)
  )

  req = curl::curl_fetch_memory(paste0('https://api.twitch.tv/helix/streams?game_id=', game_id,'&first=100'),
                                handle = h)
  streams <- req$content %>% rawToChar %>% jsonlite::parse_json()
  stream_data <- lapply(streams$data, as.data.frame %>% select(id, user_id, user_name, game_id, type, title, viewer_count, started_at, language)) %>%
    bind_rows
  #stream_data <- lapply(streams$data, function(x) x)
  return(stream_data)
}
