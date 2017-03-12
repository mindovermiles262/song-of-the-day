#Song of the Day Podcast Catcher
Automatically add The Current's, KEXP's, and KCRW's song of the day to Spotify playlist

Spotify Playlist can be found [here](https://open.spotify.com/user/andyduss/playlist/1VJVFypnr5RFbUvRIEF6Pu)

##Use
Obtain authentication key from [Spotify's API Console](https://developer.spotify.com/web-api/console/post-playlist-tracks/) and save it in a new file `user_token` in main directory.
Set the playlist that songs are added to by changing :playlist_id in `./lib/add-track.rb #configure`to valid playlist URI.
Then run `ruby main.rb` from main directory on daily basis

##Add historic songs to new playlist
Run `./lib/get-historic-[station].rb` to generate list of historic tracks (stored in ./data/)
then run `./lib/add-historic-[station].rb` to add files to playlist

##Requirements
* nokogiri

##Development Languages
* Ruby v2.4

##TODO
1. ~~Add songs to Spotify Playlist~~
2. Make daily scraper
3. Add KEXP, KCRW
4. Add automatic authentication

##Contributing
Please follow a "fork-and-pull" workflow when Contributing

1. Fork the repo on GitHub
2. Clone the project to your own machine
3. Commit changes to your own branch
4. Push your work back up to your fork
5. Submit a Pull request so that we can review your changes

##Copyright Notice
Copyright 2017 Andy Duss

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
