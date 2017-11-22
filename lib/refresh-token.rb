require 'net/http'
require_relative '../config/configure'
require 'json'
require 'base64'
require 'uri'

def refresh
  configure_env()  
  auth = 'Basic ' + Base64.strict_encode64("#{ENV["client_id"]}:#{ENV["client_secret"]}")
  uri = URI.parse('https://accounts.spotify.com/api/token')
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = auth
  request.set_form_data(
    "grant_type" => "refresh_token",
    "refresh_token" => ENV["refresh_token"]
  )
  req_options = {
    use_ssl: uri.scheme == "https"
  }
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  #puts response.body
  # session[:creds] = response.body
  return JSON.parse(response.body)['access_token']
end