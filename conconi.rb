#!/usr/bin/env ruby1.9.1

require 'optparse'

options = {
  speed_start_kmh: 8,
  speed_increase_kmh: 0.5,
  speed_end_kmh: 30,
  nr_points_per_lap: 5,
  distance_between_points_m: 20,
  wav_file: File.join(File.dirname(__FILE__), 'sounds', '01.wav')
}
OptionParser.new do |opts|
  opts.banner = "Usage: %s [options]" % [ __FILE__ ]
  opts.on("-s", "--speed-start SPEED", Integer, "Start speed in km/h, default: %s" % [ options[:speed_start_kmh] ]) do |s|
    options[:speed_start_kmh] = s
  end
  opts.on("-e", "--speed-end SPEED", Integer, "End speed in km/h, default: %s" % [ options[:speed_end_kmh] ]) do |e|
    options[:speed_end_kmh] = e
  end
  opts.on("-i", "--speed-increase INC", Float, "Increase speed by km/h at every step, default: %s" % [ options[:speed_increase_kmh] ]) do |i|
    options[:speed_increase_kmh] = i
  end
  opts.on("-p", "--nr-points-lap POINTS", Integer, "Number of points to pass per lap, default: %s" % [ options[:nr_points_per_lap] ]) do |i|
    options[:nr_points_per_lap] = i
  end
  opts.on("-d", "--dist-between-points DIST", Integer, "Distance between two points, in meters, default: %s" % [ options[:distance_between_points_m] ]) do |i|
    options[:distance_between_points_m] = i
  end
  opts.on("-f", "--sound-file PATH.wav", "WAV file to play at each step, default: %s" % [ options[:wav_file] ]) do |f|
    if not File.exists?(f)
      puts "WAV file '%s' does not exist." % [ f ]
      raise
    end
    options[:wav_file] = f
  end
end.parse!
options[:distance_per_lap_m] = options[:distance_between_points_m] * options[:nr_points_per_lap]

# Calculate intervals.
# Map each interval (time in sec between sounds)
# to the number of points passed (= the nr of sounds played)
# and the total distance run.
a = options[:speed_start_kmh]
b = options[:speed_end_kmh]
i = options[:speed_increase_kmh]
d = options[:distance_between_points_m]
n = options[:nr_points_per_lap]
sec_per_hour = 60 * 60
intervals = a.step(b, i).map do |speed_kmh|
  speed_mh = speed_kmh * 1000
  [ (sec_per_hour / speed_mh * d) ] * n
end.flatten

# Create a fiber for playing sounds.
start_time = nil
last_time = nil
f = Fiber.new do
  while true do
    unless start_time
      start_time = Time.now.to_f
      last_time = start_time
      puts "START!"
    else
      puts "%.4f sec" % [ Time.now.to_f - start_time ]
    end
    system('aplay --quiet sounds/01.wav')
    Fiber.yield
  end
end

# Play a sound at each interval.
last_time = start_time
f.resume
intervals.each do |interval, meta|
  while (Time.now.to_f - last_time) < interval
  end
  last_time = Time.now.to_f
  f.resume
end
