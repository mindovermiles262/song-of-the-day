# Updates KEXP Song of the Day. Returns song name and artist as the string
# "<ARTIST> - <SONG>" (if available), otherwise returns nil
def get_kexp
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    today = (sprintf '%02d', Date.today.day) + " " + Date::MONTHNAMES[Date.today.month][0..2].to_s + " " + Date.today.year.to_s
    # today = "01 Sep 2017"
    # today = "24 Jul 2020"

    # get SOTD XML
    # page = Nokogiri::XML(open("http://feeds.kexp.org/kexp/songoftheday"))
    page = Nokogiri::XML(open("https://www.omnycontent.com/d/playlist/bad5d079-8dcb-4630-8770-aa090049131d/32b2ac38-5a48-4300-9fa6-aa40002038b5/4ac1c451-4315-4096-ab9b-aa40002038c4/podcast.rss"))
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
