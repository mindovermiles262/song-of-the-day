def update_the_current
    ## Updates The Current Song of the Day

    require 'nokogiri'
    require 'open-uri'
    require 'date'
    require_relative './get-track-uri'
    require_relative './add-track'

    today = Date::MONTHNAMES[Date.today.month] + " " + Date.today.day.to_s + ", " + Date.today.year.to_s # => "March 10, 2017"
    today = "March 10, 2017"

    new_song = false

    # get SOTD page HTML
    page = Nokogiri::HTML(open('http://www.thecurrent.org/collection/song-of-the-day'))
    page_date = page.css('time') #get all <time> tags
    add = String.new
    page_date.each do |timetag|
        if timetag.text == today # match dates
            add = timetag.ancestors.xpath('h2').text.strip
            new_song = true
        end
    end

    if new_song
        # Update TheCurrentSOTD.txt file, adding most recent song to beginning
        file_to_read = './data/TheCurrentSOTD.txt'
        file = IO.read(file_to_read) 
        open(file_to_read, 'w') { |f| f << add << "\n" << file} 

        # Get Spotify URI of SOTD
        uri = get_track_uri(add)
        
        # Adds SOTD to Playlist
        puts "Adding song '#{add}' to playlist"
        add_track(uri)
    end
end