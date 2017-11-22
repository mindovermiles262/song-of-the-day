require './lib/refresh-token'
require './lib/add-new-songs'

auth_token = refresh()
ENV["access_token"] = auth_token
add_new_songs