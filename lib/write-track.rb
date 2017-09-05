def write_track(track_name, file)
  f = File.open(file, 'r')
    top_line = f.readline.strip!
    if top_line.strip == track_name
      #TODO : Check this
      f.close
      puts "#{track_name} already added to #{file}"
      return nil
    else
      original = IO.read(f)
      File.open(f, 'w') { |ff| ff << track_name << "\n" << original }
    end
  f.close
  return track_name
end
