require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-spotify'
require 'base64'
require 'uri'

client_id = "3a8d634974a646229f282aa9c163b1ce"
client_secret = "f1fdc2355fb74acfb33e29719588da69"
id64 = Base64.strict_encode64(client_id)
secret64 = Base64.strict_encode64(client_secret)
auth = "Basic " + Base64.strict_encode64("#{client_id}:#{client_secret}")

use OmniAuth::Builder do
  provider :spotify, client_id, client_secret,
            scope: 'playlist-modify-public'
end

configure do
  enable :sessions
end

helpers do
  def admin?
    session[:admin]
  end
end

get '/' do
	"Hello World"
end

get '/login' do
  session[:code] = nil
  redirect to("/auth/spotify")
end 

get '/auth/spotify/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401, 'Not Authorized')
  session[:code] = params[:code]
  session[:state] = params[:state]
  "#{session[:code]}"
  # redirect to '/refresh'
end

get '/refresh' do
  uri = URI.parse('https://accounts.spotify.com/api/token')
  resp = Net::HTTP.post_form(uri,
      "grant_type" => "authorization_code",
      "refresh_token" => "refresh_token",
      "code" => session[:code].to_s,
      "redirect_uri" => "http://localhost:4567/auth/spotify/callback",
      "client_id" => client_id,
      "client_secret" => client_secret)

  # auth_options = {
  #   url: 'https://accounts.spotify.com/api/token',
  #   headers: { 'Authorization': 'Basic ' + auth },
  #   form: {
  #     grant_type: 'refresh-token',
  #     refresh_token: 'refresh_token'
  #   }
  # }.to_json

  # req = Net::HTTP.post (auth_options)
  
  # req = Net::HTTP.post URI(),
    # { 
    #   "grant_type" => "authorization_code", 
    #   "code" => session[:code],
    #   "redirect_uri" => "http%3A%2F%2Flocalhost%3A4567",
    #   "client_id" => client_id,
    #   "client_secret" => client_secret
    # }.to_json
    # {
    #   "Authorization" => auth, 
    #   "Content-Type" => 'application/x-www-form-urlencoded' 
    # }
  "#{resp.body}<br>"
end