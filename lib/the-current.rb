# Updates The Current Song of the Day. Returns song name and artist as the 
# string "<ARTIST> - <SONG>" (if available), otherwise returns nil
def get_the_current
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    today = Date::MONTHNAMES[Date.today.month] + " " + Date.today.day.to_s + ", " + Date.today.year.to_s # => "March 10, 2017"
    today = "August 30, 2017"

    # get SOTD page HTML
    page = Nokogiri::HTML(open('http://www.thecurrent.org/collection/song-of-the-day'))
    page_date = page.css('time') #get all <time> tags
    add_the_current = String.new
    page_date.each do |timetag|
        if timetag.text == today # match dates
            add_the_current = timetag.ancestors.xpath('h2').text.strip
            return add_the_current
        end
    end
    return nil
end