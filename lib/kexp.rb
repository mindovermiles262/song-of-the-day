# Updates KEXP Song of the Day. Returns song name and artist as the string
# "<ARTIST> - <SONG>" (if available), otherwise returns nil
def get_kexp
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    today = (sprintf '%02d', Date.today.day) + " " + Date::MONTHNAMES[Date.today.month][0..2].to_s + " " + Date.today.year.to_s
    today = "01 Sep 2017" # TODO: comment out this line

    # get SOTD XML
    page = Nokogiri::XML(open("http://feeds.kexp.org/kexp/songoftheday"))
    dates = page.xpath('//pubDate')
    add = String.new
    dates.each do |tag|
        if tag.text.include?(today)
            add = tag.ancestors.xpath('title').text.strip[0..-21]
            return add
        end
    end
    return nil
end