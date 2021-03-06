# Adds all songs in ./data/KEXPSOTD.txt to Spotify Playlist
require_relative './add-track'
require_relative './get-track-uri'

f = File.open('./data/KEXP-SOTD.txt')
log = []

# get number of lines in file
count = 0
File.open('./data/KEXP-SOTD.txt') {|f| count = f.read.count("\n")}

# Add historic tracks to Spotify from bottom up. 
while count > 0
    track = IO.readlines('./data/KEXP-SOTD.txt')[count-1].strip!
    begin
        uri = get_track_uri(track)
    rescue
        uri = false
    end
    if uri == false
        log << track
    else
        puts "Fetched URI for #{track}"
        add_track(uri)
    end
    count -= 1
end
f.close

# write log file of songs not found by Spotify API
log_file = File.new('./log/historic_kexp_songs_not_found.log', 'w')
log_file.write(log.join("\n"))
log_file.close