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