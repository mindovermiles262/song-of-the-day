require_relative './lib/cli-refresh-token'
require_relative './lib/add-new-songs'

ENV["access_token"] = cli_refresh_token()

add_new_songs()
