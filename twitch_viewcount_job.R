require(twitchETL)
require(dplyr)
require(readr)
library(httr)

# get access token
clientID <- 'xxx'
clientSecret <- 'xxx'
r <- POST(paste0("https://id.twitch.tv/oauth2/token?client_id=", clientID, "&client_secret=", clientSecret, "&grant_type=client_credentials"))
stop_for_status(r)
access_token <- content(r, "parsed", "application/json")$access_token

query_timestamp <- Sys.time() %>% as.character

topGames <- getTopGameIDs(clientID, access_token, 10)
gameIDs <- topGames$game_id %>% as.character

topGamesStreams <- lapply(gameIDs, function(g) {
      Sys.sleep(2)
      return(getCurrentStreams(clientID, access_token, game_id = g))
  }) %>% bind_rows

df <- topGamesStreams %>%
  left_join(topGames, by = 'game_id')

# write to CSV
df %>%
  write_csv(paste0('~/twitch_snapshot_', Sys.time(), '.csv'))

# OR write to database
db <- RMySQL::dbConnect(RMySQL::MySQL(), user = "xxx", password = 'xxx', dbname = "xxx", host = "localhost")
RMySQL::dbWriteTable(db, value = df %>% mutate(query_timestamp = query_timestamp), name = "snapshots", append = TRUE, row.names = F)
dbDisconnect(db)
