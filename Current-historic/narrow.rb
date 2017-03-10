require "Nokogiri"
a = []
list = File.new('list.txt', 'w')
doc = Nokogiri::HTML(File.read("allsite.html"))
list.write(doc.search('h2').text)
list.close

File.open('list.txt').each do |line|
    if line.length > 6
        a << line.strip!
    end
end
f = File.new('finished.txt', 'w')
f.write(a.join("\n"))
f.close()
