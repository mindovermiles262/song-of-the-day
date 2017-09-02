# Updates KCRW Song of the Day. Returns song name and artist as the string
# "<ARTIST>: <SONG>" (if available), otherwise returns nil
def kcrw
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    today = (sprintf '%02d', Date.today.day) + " " + Date::MONTHNAMES[Date.today.month][0..2].to_s + " " + Date.today.year.to_s
    # today = "29 Sep 2016"

    page = Nokogiri::XML(open("http://feeds.kcrw.com/podcast/show/tu"))
    dates = page.xpath('//pubDate') # search for pubDate
    add = String.new
    dates.each do |tag|
        if tag.text.include?(today)
            add = tag.ancestors.xpath('title').text.strip[0..-17]
            return add
        end
    end
    return nil
end