#!/usr/bin/env ruby

require 'pp'
require 'fileutils'

@base_directory = '/home/tango'
@directories_to_match = [ '^program_creator-', '^web_client-' ]
@num_days_to_keep = 5
@debug = false

def get_file_list()
  file_list = []
  exclude_list = []
  delete_files_older_than = Time.now - (@num_days_to_keep*24*60*60)
  Dir.entries(@base_directory).each do |dir|
    # Check to see if it's a symlink & get target if so
    if File.symlink?(dir)
      s_target = File.readlink(dir)
      exclude_list.push(s_target)
      next
    end

    @directories_to_match.each do |pattern|
      if (dir).match(pattern)
        puts "Match! #{dir}" if @debug
        file_list.push(dir) if File.lstat(dir).mtime < delete_files_older_than
      end
    end
  end
  # Purge any symlink targets
  exclude_list.each { |f| file_list.delete(f) }
  file_list
end

def clean_file(file)
  puts "Cleaning #{file}"
  FileUtils.rm_r(file)
end

get_file_list.each do |file|
  clean_file(file)
end