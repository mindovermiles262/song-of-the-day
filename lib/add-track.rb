# Configure Spotify destination playlist and Authorization Token
def configure
    raise Exception.new("No User Token File") unless File.exist?('./user_token')
    begin
        token = File.read('./user_token')
    end

    config = {
        :playlist_id => "1VJVFypnr5RFbUvRIEF6Pu",
        :user_token => token
    }
    return config
end

# Add track to Spotify Playlist via Track URI
# Returns FALSE if unsuccessful
def add_track(track_uri)
    require 'net/http'
    require 'uri'

    config = configure #set playlist_id and user_token
    playlist_id = config[:playlist_id]
    token = config[:user_token]

    uri = URI.parse("https://api.spotify.com/v1/users/andyduss/playlists/" + playlist_id + "/tracks?position=0&uris=" + track_uri)
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