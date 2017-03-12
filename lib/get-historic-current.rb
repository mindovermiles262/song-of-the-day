# Generates list of previous The Current SOTD tracks
# Stored in ./data/TheCurrentSOTD.txt
# Use ./lib/add-historic-current.rb to add songs to Spotify Playlist

# Be sure to check last page number and update 'for' loop accordingly!

require 'nokogiri'
require 'open-uri'

f = File.new('../data/TheCurrentSOTD.txt', 'w+')
for i in 1..32
    puts "Processing page #{i} . . ."
    a = []
    page = Nokogiri::HTML(open("http://www.thecurrent.org/collection/song-of-the-day?page=" + i.to_s))
    list = (page.search('h2').text)
    list.each_line do |line|
        if line.length > 6
            f.write(line.strip! + "\n")
        end
    end
end
f.close()