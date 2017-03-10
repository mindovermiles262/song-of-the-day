## Updates The Current Song of the Day

# TODO: Change write location to beginning of file

require 'nokogiri'
require 'open-uri'
require 'date'

today = Date::MONTHNAMES[Date.today.month] + " " + Date.today.day.to_s + ", " + Date.today.year.to_s # => "March 10, 2017"

f = File.open('./historic/TheCurrentSOTD.txt', 'a+')
page = Nokogiri::HTML(open('http://www.thecurrent.org/collection/song-of-the-day'))
page_date = page.css('time') #get all <time> tags
page_date.each do |line|
    if line.text == today
        f.write(line.ancestors.xpath('h2').text.strip! + "\n")
    end
end
f.close