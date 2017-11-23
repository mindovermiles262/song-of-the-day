require './lib/cli-refresh-token'
require './lib/add-new-songs'

ENV["access_token"] = cli_refresh_token()

add_new_songs()