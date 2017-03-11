## Updates The Current Song of the Day

# TODO: Change write location to beginning of file

require 'nokogiri'
require 'open-uri'
require 'date'

today = Date::MONTHNAMES[Date.today.month] + " " + Date.today.day.to_s + ", " + Date.today.year.to_s # => "March 10, 2017"

# get SOTD page HTML
page = Nokogiri::HTML(open('http://www.thecurrent.org/collection/song-of-the-day'))
page_date = page.css('time') #get all <time> tags
add = ""
#update_file = File.new('../tmp/add.temp', 'w+')
page_date.each do |timetag|
    if timetag.text == today # match dates
        add = timetag.ancestors.xpath('h2').text.strip
        #update_file.write(timetag.ancestors.xpath('h2').text.strip)
    end
end
#update_file.close

file_to_read = '../data/TheCurrentSOTD.txt'
file = IO.read(file_to_read) 
open(file_to_read, 'w') { |f| f << add << "\n" << file} 