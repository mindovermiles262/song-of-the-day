# Adds all songs in ./data/TheCurrentSOTD.txt to Spotify Playlist
require_relative './add-track'
require_relative './get-track-uri'

f = File.open('./../data/TheCurrentSOTD.txt')

# get number of lines in file
count = 0
File.open('./../data/TheCurrentSOTD.txt') {|f| count = f.read.count("\n")}

# Add historic tracks bottom up. 
# Method add_track adds songs to top of playlist so adding tracks bottom up keeps playlist in order
while count > 0
    track = IO.readlines('./../data/TheCurrentSOTD.txt')[count-1]
    uri = get_track_uri(track)
    puts "Fetched URI for track '#{track}"
    add_track(uri)
    count -= 1
end