require 'nokogiri'
require 'open-uri'
f = File.new('TheCurrentSOTD.txt', 'w')
for i in 1..32
    puts "Page #{i}"
    a = []
    page = Nokogiri::HTML(open("http://www.thecurrent.org/collection/song-of-the-day?page=" + i.to_s))
    list = (page.search('h2').text)
    list.each_line do |line|
        if line.length > 6
            a << line.strip!
        end
    end
    f.write(a.join("\n"))
end

f.close()