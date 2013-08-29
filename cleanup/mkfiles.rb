#!/usr/bin/env ruby

require 'date'
require 'time'

def parse_line(line)
  d = line.split[5..7]
  raw_date = "#{d[2]} #{d[1]} #{d[3]}"
  date = Time.parse("#{raw_date}")
  #puts "date #{date}"
  file = line.split[8..10].join(' ')
  #puts "file #{file}"
  return date,file
end

File.open('/home/tango/filelist.txt').each do |line|
  line = line.chomp
  if line =~ /(^\#)|(^$)/
    next
  else
    puts line
    (date, file) = parse_line(line)
  end

  if file =~ /\s+->\s+/
    (l, r) = file.split(/\s+->\s+/)
    puts "Link name: #{l}"
    puts "Link target: #{r}"
    if File.exists?(r) && ! File.exists?(l)
      File.symlink(r, l)
    elsif ! File.exists?(r)
      puts "Target file #{r} missing"
    elsif File.exists?(l)
      puts "Symlink already exists"
    end
  else
    if File.directory?(file)
      puts "#{file} already exists"
      next
    else
      puts "Creating #{file}"
      Dir.mkdir(file)
      File.utime(date,date,file)
    end
  end
end

