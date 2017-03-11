def add_track(track_uri)
    require 'net/http'
    require 'uri'

    playlist_id = '1VJVFypnr5RFbUvRIEF6Pu' # 'Song of the Day'
    token = # User authentication token here

    uri = URI.parse("https://api.spotify.com/v1/users/andyduss/playlists/" + playlist_id + "/tracks?position=0&uris=" + track_uri)
    puts uri
    request = Net::HTTP::Post.new(uri)
    request["Accept"] = "application/json"
    request["Authorization"] = token

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
    end
end

add_track('spotify%track%63oJy2WdIKujilh6TQ14cr') # Add '40 Watt - Elel' to Playlist 'Song of the Day'