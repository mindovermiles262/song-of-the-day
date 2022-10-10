# Adds songs from a list file, 'songs.txt'

require_relative 'lib/get-track-uri'
require_relative 'lib/add-track'
require_relative 'lib/cli-refresh-token'

ENV["access_token"] = cli_refresh_token()

File.readlines('songs.txt').each do |line|
  puts("[*] Adding song #{line}")
  uri = get_track_uri(line)
  add_track(uri)
end

