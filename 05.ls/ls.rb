#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def file_type(type)
  case type
  when 'fifo'
    print 'p'
  when 'characterSpecial'
    print 'c'
  when 'directory'
    print 'd'
  when 'blockSpecial'
    print 'b'
  when 'file'
    print '-'
  when 'link'
    print 'l'
  when 'socket'
    print 's'
  end
end

def user_group_name
  user_id    = Process.uid
  user_name  = Etc.getpwuid(user_id).name
  group_id   = Process.gid
  group_name = Etc.getgrgid(group_id).name
  print '  '
  print user_name
  print '  '
  print group_name
  print '  '
end

opt = OptionParser.new
params = opt.getopts(ARGV, 'alr')
files = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if params['r']
max_size = files.map(&:size).max
column = 3
fsize = files.size
lines = fsize / column
trust = fsize % column
lines += 1 if trust != 0 && lines > 1
line = files.each_slice(lines).to_a
i = 0
if lines <= 1
  until i == trust
    line[i].push(*line[i + 1])
    line.delete_at(i + 1)
    i += 1
  end
end
line.map! { |a| a.values_at(0..lines) }
results = line.transpose

if params['l']
  files.each do |fl|
    files_info = File.lstat(fl)
    file_type(files_info.ftype)
    permissions = files_info.mode.to_s(8).split(//).pop(3)
    permissions.each do |permission|
      case permission
      when '0'
        print '---'
      when '1'
        print '--x'
      when '2'
        print '-w-'
      when '3'
        print '-wx'
      when '4'
        print 'r--'
      when '5'
        print 'r-x'
      when '6'
        print 'rw-'
      when '7'
        print 'rwx'
      end
    end
    print '  '
    print files_info.nlink
    user_group_name
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
  results.map do |items|
    puts items.map { |item| "%-#{max_size}s  " % item }.join
  end
end
