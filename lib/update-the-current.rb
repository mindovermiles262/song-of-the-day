## Updates The Current Song of the Day
def update_the_current
    require 'nokogiri'
    require 'open-uri'
    require 'date'
    require_relative './get-track-uri'
    require_relative './add-track'

    today = Date::MONTHNAMES[Date.today.month] + " " + Date.today.day.to_s + ", " + Date.today.year.to_s # => "March 10, 2017"
    # today = "June 4, 2017" # for devopment purposes

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

    puts "Song of the Day: #{add}"

    if new_song
        # Get Spotify URI of SOTD
        uri = get_track_uri(add)

        # Check if song has already been added
        check = File.open('./data/TheCurrentSOTD.txt', 'r') { |l| l.readline }.strip
        if check == add
            puts "Song already added to ./data/TheCurrentSOTD.txt"
            return
        end

        # Add SOTD to Spotify Playlist
        add_successful = add_track(uri)

        # Update TheCurrentSOTD.txt adding most recent song to beginning if add to spotify successful or song not found in Spotify DB
        if add_successful || uri == ""
            file_to_read = './data/TheCurrentSOTD.txt'
            file = IO.read(file_to_read)
            if File.open(file_to_read) { |f| f.readline }.strip != add
                File.open(file_to_read, 'w') { |f| f << add << "\n" << file} 
            end
        end
        
        
    end
end