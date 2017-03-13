# Adds all songs in ./data/KEXPSOTD.txt to Spotify Playlist
require_relative './add-track'
require_relative './get-track-uri'

f = File.open('./data/KEXP-SOTD.txt')

# get number of lines in file
count = 0
File.open('./data/KEXP-SOTD.txt') {|f| count = f.read.count("\n")}

# Add historic tracks bottom up. 
# Method add_track adds songs to top of playlist so adding tracks bottom up keeps playlist in order
while count > 0
    track = IO.readlines('./data/KEXP-SOTD.txt')[count-1]
    begin
        uri = get_track_uri(track)
        puts "Fetched URI for track '#{track}"
        add_track(uri)
        count -= 1
    rescue
        log = File.new("./log/invalid_uri_log_#{Time.new.to_s.gsub(" ","_")[0..18]}.log", "w")
        log.write(track)
        log.close
        count -= 1
    end
end
f.close