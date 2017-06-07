require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
# require './lib/update-the-current'
require './lib/get-today'

get '/' do
	thecurrent = get_the_current != "" ? get_the_current : "No New SOTD Today"
	kexp = get_kexp != "" ? get_kexp : "No New SOTD Today"
	kcrw = get_kcrw != "" ? get_kcrw : "No New SOTD Today"
	erb :index, :locals => { :thecurrent => thecurrent, :kexp => kexp, :kcrw => kcrw }
end

get '/login' do
	client_id = '37710a0bc4a5466c885cca32c3ded2ce'
	client_secret = 'd572a3f343ae4ae485e88f86a2f7ffbf'
	redirect_uri = 'http%3A%2F%2Flocalhost%3A4567'
	state = 'thisisthestateofspotify'
	scope = 'playlist-modify-public'
	show_dialog = 'false'
	full_uri = 'https://accounts.spotify.com/authorize/?client_id=' + client_id + '&response_type=code&redirect_uri=' + redirect_uri + '&scope=' + scope

	uri = URI(full_uri)
	resp = Net::HTTP.get(uri)

	erb :login, :locals => { :resp => resp, :uri => uri }
end

post '/api/login' do
	redirect '/success'
end

get '/callback' do
	code = params['code']
	erb :callback, :locals => { :code => code }
end

get '/en/status' do
	redirect '/success'
end

get '/success' do
	"success"
end