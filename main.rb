# Updates all stations
# Set to run on daily basis to automatically add songs

require_relative './lib/update-the-current'
require_relative './lib/update-kexp'
require_relative './lib/update-kcrw'

# update The Current Song of the Day
puts "Updating The Current . . ."
update_the_current

# update KEXP Song of the Day
puts "Updating KEXP . . ."
update_kexp

# update KCRW Today's Top Tune
puts "Updating KCRW . . ."
update_kcrw