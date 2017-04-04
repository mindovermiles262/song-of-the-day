def update_kcrw
    require 'nokogiri'
    require 'open-uri'
    require 'date'
    require_relative './get-track-uri'
    require_relative './add-track'

    today = (sprintf '%02d', Date.today.day) + " " + Date::MONTHNAMES[Date.today.month][0..2].to_s + " " + Date.today.year.to_s
    # today = "03 Mar 2017"

    new_song = false

     # get SOTD XML
    page = Nokogiri::XML(open("http://feeds.kcrw.com/podcast/show/tu"))
    dates = page.xpath('//pubDate') # search for pubDate
    add = String.new
    dates.each do |tag|
        if tag.text.include?(today)
            add = tag.ancestors.xpath('title').text.strip[0..-17]
            new_song = true
        end
    end
    
    puts "SOTD: #{add}"

    if new_song
        # Get Spotify URI of SOTD
        uri = get_track_uri(add)
        puts "Fetched track '#{add}'"

        # Check if song has already been added
        top_line = File.open('./data/KCRW-SOTD.txt', 'r') { |l| l.readline }.strip
        if top_line == add
            puts "Song already added"
            return
        end

        # Add SOTD to Spotify Playlist
        add_successful = add_track(uri)

        # Update KCRW-SOTD.txt adding most recent song to beginning if add to spotify successful or not found in Spotify DB
        if add_successful || uri == 0
            file_to_read = './data/KCRW-SOTD.txt'
            file = IO.read(file_to_read)
            if File.open(file_to_read) { |f| f.readline }.strip != add
                File.open(file_to_read, 'w') { |f| f << add << "\n" << file} 
            end
        end
    end
end