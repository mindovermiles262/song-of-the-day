require 'nokogiri'
require 'open-uri'

all = File.new('allsite.html', 'w+')
for i in 1..32
    page = Nokogiri::HTML(open("http://www.thecurrent.org/collection/song-of-the-day?page=" + i.to_s))
    all.write(page)
end
all.close

a = []
list = File.new('raw.txt', 'w')
doc = Nokogiri::HTML(File.read("allsite.html"))
list.write(doc.search('h2').text)
list.close

File.open('raw.txt').each do |line|
    if line.length > 6
        a << line.strip!
    end
end
f = File.new('finished.txt', 'w')
f.write(a.join("\n"))
f.close()