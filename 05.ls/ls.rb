#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
def results(file)
  column = 3
  fsize = file.size
  row = fsize / column
  row += 1 if trust != 0
  result = Array.new(column) { Array.new(row) }
  (0...column).each do |col_index|
    (0...row).each do |row_index|
      result[col_index][row_index] = file.shift if row_index.zero? || file.size >= (column - col_index)
    end
  end
  result
end

def file_type(type)
  types = { "fifo": 'p', "characterSpecial": 'c', "directory": 'd', "blockSpecial": 'b', "file": '-', "link": 'l', "socket": 's' }
  types[type.to_sym]
end

def to_display_user_group_name
  user_id    = Process.uid
  user_name  = Etc.getpwuid(user_id).name
  group_id   = Process.gid
  group_name = Etc.getgrgid(group_id).name
  print "  #{user_name}  #{group_name}  "
end

def file_permission(permission)
  permissions = { "0": '---', "1": '--x', "2": '-w-', "3": '-wx', "4": 'r--', "5": 'r-x', "6": 'rw-', "7": 'rwx' }
  permissions[permission.to_sym]
end

opt = OptionParser.new
params = opt.getopts(ARGV, 'alr')
files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if params['r']

if params['l']
  files.each do |fl|
    files_info = File.lstat(fl)
    print file_type(files_info.ftype)
    permissions = files_info.mode.to_s(8).split(//).pop(3)
    permissions.each do |permission|
      print file_permission(permission)
    end
    print '  '
    print files_info.nlink
    to_display_user_group_name
    print files_info.size
    print '  '
    print files_info.mtime.month
    print ' '
    print files_info.mtime.mday
    print ' '
    print '0' if files_info.mtime.hour.to_s.size == 1
    print files_info.mtime.hour
    print ':'
    print '0' if files_info.mtime.min.to_s.size == 1
    print files_info.mtime.min
    print ' '
    print fl
    print "\n"
  end
else
  max_size = files.map(&:size).max
  results(files).transpose.each do |items|
    puts items.map { |item| format("%-#{max_size}s  ", item) }.join
  end
end
