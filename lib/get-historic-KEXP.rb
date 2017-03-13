# Generates list of all KEXP Song of the Day Tracks
# List stored in ./data/KEXPSOTD.txt
# use ./lib/add-historic-KEXP.rb to add songs to Spotify Playlist

require 'nokogiri'
require 'open-uri'

f = File.new('./data/KEXP-SOTD.txt', 'w')
page = Nokogiri::XML(open("http://feeds.kexp.org/kexp/songoftheday")) # get entire podcast xml
titles = page.xpath('//title') # search for song titles in "<titles>"
lines = titles.map(&:text).join("\n") # separate <titles> on new lines

# write lines to file
lines.each_line do |x|
    f.write(x.strip + "\n") unless x.to_s.include?("KEXP Song of the Day")
end
f.close