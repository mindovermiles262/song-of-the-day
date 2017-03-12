def configure
    raise Exception.new("No User Token File") unless File.exist?('./user_token') || File.exist?('./../user_token')
    begin
        token = File.read('./user_token')
    rescue
        token = File.read('./../user_token')
    end

    config = {
        :playlist_id => "1VJVFypnr5RFbUvRIEF6Pu",
        :user_token => token
    }
    return config
end

def add_track(track_uri)
    require 'net/http'
    require 'uri'

    config = configure()
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
    else
        puts "Error code #{response.code}. Track not added to Spotify."
        @error_log[:track_uri] = [Time.new, response.code, response.body]
    end
    begin
        log = File.new("./log/error_log_#{Time.new.to_s.gsub(" ","_")[0..18]}.log", "w")
    rescue
        log = File.new("./../log/error_log_#{Time.new.to_s.gsub(" ","_")[0..18]}.log", "w")
    end
    log.write(@error_log)
    log.close
end