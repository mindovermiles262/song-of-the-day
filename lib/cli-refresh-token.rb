def cli_refresh_token
  require 'json'
  require 'base64'
  require 'uri'
  require 'net/http'
  require_relative '../conf/configure.rb'

  configure_env()

  uri = URI.parse('https://accounts.spotify.com/api/token')
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = 'Basic ' + Base64.strict_encode64("#{ENV["client_id"]}:#{ENV["client_secret"]}")
  request.set_form_data(
    "grant_type" => "refresh_token",
    "refresh_token" => ENV["cli_refresh_token"]
  )

  req_options = {
    use_ssl: uri.scheme == "https",
  }
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  
  # puts response.body
  
  return JSON.parse(response.body)['access_token']
end
