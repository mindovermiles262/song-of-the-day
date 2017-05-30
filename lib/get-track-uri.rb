# Get Spotify Track URI from search query
def get_track_uri(search_query)
    require 'uri'
    require 'json'
    require 'i18n'
    require 'rest-client'
    require_relative '../conf/configure'

    # Set Playlist ID and User Token
    config = configure
    playlist_id = config[:playlist_id]
    token = config[:user_token]


    # Converts UTF-8 Chars into ASCII for URI Search
    I18n.available_locales = [:en]
    query = I18n.transliterate(search_query.strip.gsub(/\(feat.+.*/,'').gsub(' ','+').gsub('&','')) #change search_query spaces to '+'

    # puts "Query: #{query}" # Debugging

    # query Spotify Web API
    response = RestClient.get 'https://api.spotify.com/v1/search?q=' + query + '&type=track', {Accept: 'application/json', 'Authorization' => 'Bearer ' + token}

    # Search the response for track URI
    resp = JSON.parse(response.body)
    resp = resp['tracks'].to_s.split(" ")
    track_uri = String.new
    resp.each do |line|
        # TODO: Rewrite using Regex
        if line.include?('uri"=>"spotify:track:')
            track_uri = line[8..-5]
        end
    end

    # Debugging Console Outputs
    # puts "Resonse: #{response}"
    puts "Spotify Response: #{response.code}"
    # puts "Track URI: #{track_uri}"

    if track_uri.length > 3
        # puts "Track URI: #{track_uri}"
        return track_uri
    elsif track_uri.length == 0 #write error log with song title and search query
        puts "Spotify: Song Not Found"
        return track_uri
    end
end