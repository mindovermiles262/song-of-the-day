require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-spotify'
require 'base64'
require 'uri'

client_id = "7d8fb5b386a54b499283b2841fb8b61a"
client_secret = "09d5405fbf444f62bb20e7fe6b6e74c9"
id64 = Base64.strict_encode64(client_id)
secret64 = Base64.strict_encode64(client_secret)
auth = "Basic " + Base64.strict_encode64("#{client_id}:#{client_secret}")

configure do
  enable :sessions
end

use OmniAuth::Builder do
  provider :spotify, client_id, client_secret, scope: 'playlist-modify-public playlist-modify-private user-read-email'
end

get '/' do
  # erb :index, :locals => {  :thecurrent => @@thecurrent, 
  #                           :kexp => @@kexp, 
  #                           :kcrw => @@kcrw }
  "INDEX <br> Token: #{session[:creds].token if session[:creds]}"
end

get '/login' do
  if session[:creds]
    "Logged in"
  else
    redirect to("/auth/spotify?show_dialog=true")
  end
end 

get '/auth/spotify/callback' do
  session[:code] = params[:code]
  session[:creds] = request.env['omniauth.auth'].credentials
  session[:user] = request.env['omniauth.auth'].info
  redirect to '/'
end

get '/refresh' do
  refresh
end

get '/update' do
  refresh
  @@kexp = kexp = get_kexp != "" ? get_kexp : "No New SOTD Today"
  @@thecurrent = get_the_current != "" ? get_the_current : "No New SOTD Today"
	@@kcrw = get_kcrw != "" ? get_kcrw : "No New SOTD Today"
end

def refresh
  redirect to '/login' unless session[:user]
  refresh_token = session[:creds].refresh_token
  auth = "Basic " + Base64.strict_encode64("#{client_id}:#{client_secret}")
  uri = URI.parse('https://accounts.spotify.com/api/token')
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = auth
  request.set_form_data(
    "grant_type" => "refresh_token",
    "refresh_token" => refresh_token,
  )
  
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  session[:creds] = response.body
end