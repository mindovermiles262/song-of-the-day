require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-spotify'
require 'base64'
require 'uri'
require_relative './lib/stations'
require_relative './config/configure'
require_relative './lib/add-new-songs'

configure do
  enable :sessions
end

helpers do
  configure_env
end

use OmniAuth::Builder do
  provider :spotify, ENV["client_id"], ENV["client_secret"], scope: 'playlist-modify-public playlist-modify-private user-read-email'
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
    redirect to("/auth/spotify") # /auth/spotify?show_dialog=true
  end
end 

get '/auth/spotify/callback' do
  session[:code] = params[:code]
  session[:creds] = request.env['omniauth.auth'].credentials
  session[:user] = request.env['omniauth.auth'].info
  ENV['REFRESH_TOKEN'] = request.env['omniauth.auth'].credentials.refresh_token
  redirect to '/'
end

get '/new-songs' do
  rt = refresh_token
  ENV["access_token"] = rt
  add_new_songs
  redirect to '/'
end

def refresh_token
  require 'json'
  configure_env
  redirect to '/login' unless session[:user]
  # refresh_token = ENV["refresh_token"]
  auth = 'Basic ' + Base64.strict_encode64("#{ENV["client_id"]}:#{ENV["client_secret"]}")
  uri = URI.parse('https://accounts.spotify.com/api/token')
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = auth
  request.set_form_data(
    "grant_type" => "refresh_token",
    "refresh_token" => ENV["REFRESH_TOKEN"]
  )
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  # session[:creds] = response.body

  # Uncomment line below to obtain refresh token for CLI interface
  #puts "!!!! REFRESH TOKEN: #{ENV["REFRESH_TOKEN"]}"
  return JSON.parse(response.body)['access_token']
end