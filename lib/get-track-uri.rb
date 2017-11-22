# Get Spotify Track URI from search query
def get_track_uri(search_query)
    require 'uri'
    require 'json'
    require 'i18n'
    require 'rest-client'
    require_relative '../config/configure'

    # Set User Token
    config = configure_env
    # begin
    #     token = File.read('./config/access_token')
    # rescue
    #     raise Exception.new("Access token not avaiable. Please run app.rb")
    # end


    # Converts UTF-8 Chars into ASCII for URI Search
    I18n.available_locales = [:en]
    query = I18n.transliterate(search_query.strip.gsub(/\(feat.+.*/,'').gsub(' ','+').gsub('&','')) #change search_query spaces to '+'

    # puts "Query: #{query}" # Debugging

    # query Spotify Web API
    response = RestClient.get 'https://api.spotify.com/v1/search?q=' + query + '&type=track', {Accept: 'application/json', 'Authorization' => 'Bearer ' + ENV["access_token"]}

    # Search the response for track URI
    resp = JSON.parse(response.body)
    resp = resp['tracks'].to_s.split(" ")
    track_uri = String.new
    resp.each do |line|
        # TODO: Rewrite using Regex
        if line.include?('uri"=>"spotify:track:')
            track_uri = line[8..-5]
            # break
        end
    end

    if track_uri.length > 3
        return track_uri
    else
        return nil
    end
end