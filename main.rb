# Updates all stations
# Set to run on daily basis to automatically add songs

require_relative './lib/update-the-current'
require_relative './lib/update-kexp'
require_relative './lib/update-kcrw'

# update The Current Song of the Day
puts "Updating The Current . . ."
begin
	update_the_current
rescue
	puts "The Current unable to update!"
end

# update KEXP Song of the Day
puts "Updating KEXP . . ."
begin
	update_kexp
rescue
	puts "KEXP unable to update!"
end	


# update KCRW Today's Top Tune
puts "Updating KCRW . . ."
begin
	update_kcrw
rescue
	puts "KCRW unable to update!"
end	
