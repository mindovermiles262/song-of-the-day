require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-spotify'
require 'base64'
require 'uri'
require_relative './lib/stations'
require_relative './conf/configure'
require_relative './lib/add-new-songs'

configure do
  enable :sessions
end

helpers do
  configure_env
end

client_id = ENV["client_id"]
client_secret = ENV["client_secret"]

use OmniAuth::Builder do
  provider :spotify, client_id, client_secret, scope: 'playlist-modify-public playlist-modify-private user-read-email'
end

get '/' do
  redirect to '/login' unless session[:user]
  kexp = get_kexp
  kcrw = get_kcrw
  the_current = get_the_current
  erb :index, :locals => {  :kexp => kexp, 
                            :kcrw => kcrw,
                            :the_current => the_current }
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
  File.open('./conf/refresh_token', 'w+') { |file| file.write(request.env['omniauth.auth'].credentials.refresh_token) }
  redirect to '/'
end

get '/refresh' do
  File.open('./conf/access_token', 'w+') { |file| file.write(refresh_token) }
  redirect to '/'
end

get '/update' do
  update_sotd
end

get '/new-songs' do
  ENV["access_token"] = refresh_token
  add_new_songs
  redirect to '/'
end

def refresh_token
  require 'json'
  configure_env
  redirect to '/login' unless session[:user]
  refresh_token = ENV["refresh_token"]
  auth = 'Basic ' + Base64.strict_encode64("#{ENV["client_id"]}:#{ENV["client_secret"]}")
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

  # session[:creds] = response.body
  return JSON.parse(response.body)['access_token']
end