# Add track to Spotify Playlist via Track URI
# Returns FALSE if unsuccessful
def add_track(track_uri)
    require 'net/http'
    require 'uri'
    require_relative '../conf/configure'

    #set playlist_id and user_token
    config = configure
    playlist_id = config[:playlist_id]
    token = config[:user_token]

    uri = URI.parse("https://api.spotify.com/v1/users/andyduss/playlists/" + playlist_id.to_s + "/tracks?position=0&uris=" + track_uri.to_s)
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
    else
        puts "Track not added! Response code #{response.code}."
        @error_log[track_uri] = [Time.new, response.code, response.body]

        # create and write error log file
        timestring = [Time.new.year, Time.new.month, Time.new.day].join('-') + "_" + "#{Time.now.usec}"
        log = File.new("./log/ErrorLog_#{timestring}.log", "w")
        log.write(@error_log)
        log.close
        return false
    end
end