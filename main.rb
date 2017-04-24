# Updates all stations
# Set to run on daily basis to automatically add songs

require_relative './lib/update-the-current'
require_relative './lib/update-kexp'
require_relative './lib/update-kcrw'

# update The Current Song of the Day
puts "\nUpdating The Current . . ."
begin
	update_the_current
rescue
	puts "*****The Current unable to update!*****"
end

# update KEXP Song of the Day
puts "\n\nUpdating KEXP . . ."
begin
	update_kexp
rescue
	puts "*****KEXP unable to update!*****"
end	


# update KCRW Today's Top Tune
puts "\n\nUpdating KCRW . . ."
begin
	update_kcrw
rescue
	puts "\n*****KCRW unable to update!*****\n\n"
end	

puts "\n"
