require 'sinatra'
require 'sinatra/reloader'
require 'omniauth-spotify'

use OmniAuth::Builder do
  provider :spotify, "3a8d634974a646229f282aa9c163b1ce", "f1fdc2355fb74acfb33e29719588da69"
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
  redirect to("/auth/spotify")
end 

get '/auth/spotify/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401, 'Not Authorized')
  session[:username] = env['omniauth.auth']['info']['name']
  session[:token] = env['omniauth.auth']['credentials']['token']
  session[:secret] = env['omniauth.auth']['credentials']['secret']
  session[:expires] = env['omniauth.auth']['credentials']['expires']
  session[:expires_at] = env['omniauth.auth']['credentials']['expires_at']

  "You are now logged in as #{session[:username]}<br>
  Token: #{session[:token]}<br>
  Secret: #{session[:secret]}<br>
  Expires: #{session[:expires]}<br>
  Expires at: #{session[:expires_at]}<br>"
end

get '/auth/failure' do
  params[:message]
end 