# Add track to Spotify Playlist via Track URI
# Returns FALSE if unsuccessful
def add_track(track_uri, position=0)
    require 'net/http'
    require 'uri'
    require_relative '../conf/configure'

    #set playlist_id and user_token
    configure_env
    playlist_id = ENV["playlist_id"]
    token = ENV["access_token"]

    uri = URI.parse("https://api.spotify.com/v1/users/andyduss/playlists/" + playlist_id.to_s + "/tracks?position=" + position.to_s + "&uris=" + track_uri.to_s)
    request = Net::HTTP::Post.new(uri)
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer " + token

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
    end

    # Alert Success or Failure
    # Write failures to log
    @error_log = Hash.new
    if response.code == "201"
        puts "Successfully added track to playlist"
        return true
    elsif response.code == "200"
        puts "Successfully added track to playlist"
        return true
    elsif response.code == "400"
        # do nothing, user already alerted in 'get-track-uri'
    else
        puts "Track not added! Response code #{response.code}. See ErrorLog"
        @error_log[track_uri] = [Time.new, response.code, response.body]

        # create and write error log file
        timestring = [Time.new.year, Time.new.month, Time.new.day].join('-') + "_" + "#{Time.now.usec}"
        File.open("./log/ErrorLog_#{timestring}AT.log", "w") { |f| f.write(@error_log) }
        return response.code
    end
end