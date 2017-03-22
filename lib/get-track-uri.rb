# Get Spotify Track URI from search query
def get_track_uri(search_query)
    require 'net/http'
    require 'uri'
    require 'json'

    query = search_query.strip.gsub(' ','+') #change search_query spaces to '+'
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
    if track_uri.length > 3
        return track_uri
    else #write error log with song title and search query
        @error_log = { [search_query] => [query, resp] }
        File.open("./log/SongNotFound_#{search_query.split(" ").join("_")}_GTURI.log", "w") { |f| f.write(@error_log) }
        puts "Song not found"
        return "song_not_found"
    end
end