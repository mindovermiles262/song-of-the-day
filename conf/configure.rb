# Configure Spotify destination playlist and Authorization Token
def configure_env

  # Change these three settings when setting up
  # TODO: Remove configure secrets
  ENV["client_id"] = "7d8fb5b386a54b499283b2841fb8b61a" # Test App
  ENV["client_secret"] = "09d5405fbf444f62bb20e7fe6b6e74c9" # Test App
  ENV["playlist_id"] = "51qObhMWD2f8dmUb0t4uuE" #DevTest Playlist

  ENV["refresh_token"] = File.read('./conf/refresh_token') if File.exist?('./conf/refresh_token')
  ENV["access_token"] = File.read('./conf/access_token') if File.exist?('./conf/refresh_token')
end