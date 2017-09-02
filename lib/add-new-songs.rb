def add_new_songs
  require_relative './stations'
  require_relative './get-track-uri'
  require_relative './add-track'

  sotd = Array.new
  uri = Array.new

  sotd << get_kexp
  sotd << get_the_current
  sotd << get_kcrw

  sotd.each do |song|
    next if song.nil? || song.empty?
    uri << get_track_uri(song)
  end

  uri.each do |song|
    add_track(song)
  end
end