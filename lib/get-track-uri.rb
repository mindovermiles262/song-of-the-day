# Get Spotify Track URI from search query
def get_track_uri(search_query)
    require 'net/http'
    require 'uri'
    require 'json'
    require 'i18n' # Converts UTF-8 Chars into ASCII for URI Search Request

    I18n.available_locales = [:en]

    query = I18n.transliterate(search_query.strip.gsub(/\(feat.+.*/,'').gsub(' ','+').gsub('&','')) #change search_query spaces to '+'

    #puts "Query: #{query}" # Debugging

    # query Spotify Web API
    search = URI.parse("https://api.spotify.com/v1/search?q=" + query + "&type=track&limit=1")
    request = Net::HTTP::Get.new(search)
    request["Accept"] = "application/json"

    req_options = { use_ssl: search.scheme == "https", }

    response = Net::HTTP.start(search.hostname, search.port, req_options) do |http|
        http.request(request)
    end

    # Search the response for track URI
    resp = JSON.parse(response.body)
    resp = resp['tracks'].to_s.split(" ")
    track_uri = String.new
    resp.each do |line|
        if line.include?('uri"=>"spotify:track:')
            track_uri = line[8..-5]
        end
    end

    puts "Spotify Response: #{response.code}"

    if track_uri.length > 3
        # puts "Track URI: #{track_uri}"
        return track_uri
    elsif track_uri.length == 0 #write error log with song title and search query
        puts "Spotify: Song Not Found"
        return track_uri
    end
end