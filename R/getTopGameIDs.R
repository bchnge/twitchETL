#' Twitch ETL: Obtain top games
#'
#' @param clientID Twitch API client key (str)
#' @param numGames
#'
#' @return A dataframe containing the game IDs, game names, and pull date
#' @export
#'
#' @examples
#' getTopGameIDs('api_key', 10)

getTopGameIDs <- function(clientID, access_token, numGames = 100){
  curr_timestamp <- Sys.time()
  # Define handle for Twitch API
  h <- curl::new_handle()
  curl::handle_setopt(h, verbose = TRUE)
  curl::handle_setheaders(h, .list = list(
    'Accept' = 'application/json',
    'Client-ID' = clientID,
    'Authorization' = paste0('Bearer ', access_token))
  )

  # Retrieve results from Twitch
  req <- curl::curl_fetch_memory(paste0('https://api.twitch.tv/helix/games/top?first=', numGames),
                          handle = h)
  results <- jsonlite::parse_json(rawToChar(req$content))

  game_id_names <- data.frame(game_id = lapply(results$data, function(x) x$id) %>% unlist,
                              game_name = lapply(results$data, function(x) x$name) %>% unlist,
                              pull_timestamp = curr_timestamp)
  return(game_id_names)
}
