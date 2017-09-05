def add_new_songs
  require_relative './stations'
  require_relative './get-track-uri'
  require_relative './add-track'
  require_relative './write-track'

  sotd = Array.new
  uri = Array.new

  sotd << write_track(get_kexp, "./data/KEXP-SOTD.txt")
  sotd << write_track(get_the_current, "./data/TheCurrentSOTD.txt")
  sotd << write_track(get_kcrw, "./data/KCRW-SOTD.txt")

  # Output SOTD to console
  puts "\nSOTD: #{sotd}"

  sotd.each do |song|
    next if song.nil? || song.empty?
    uri << get_track_uri(song)
  end

  uri.each do |song|
    add_track(song)
  end
end