# -aの時
files = Dir.glob("*", File::FNM_DOTMATCH)
files = files.reverse
max_size = files.map(&:size).max
column = 7
fsize = files.size
lines = fsize / column
line = files.each_slice(lines).to_a
p line.map! {|i| i.values_at(0...lines)}
results = line.transpose
results.map do |items|
  puts items.map {|item| "%-#{max_size}s  " % item}.join
end

require 'etc'
files.each do |fl|
  fs = File.lstat(fl)
  type = fs.ftype
  case type
  when "fifo"
    print "p"
  when "characterSpecial"
    print "c"
  when "directory"
    print "d"
  when "blockSpecial"
    print "b"
  when "file"
    print "-"
  when "link"
    print "l"
  when "socket"
    print "s"
  end

  arr = fs.mode.to_s(8).split(//)
  arr = arr.pop(3)

  arr.each do |a|
    case a
    when "0"
      print "---"
    when "1"
      print "--x"
    when "2"
      print "-w-"
    when "3"
      print "-wx"
    when "4"
      print "r--"
    when "5"
      print "r-x"
    when "6"
      print "rw-"
    when "7"
      print "rwx"
    end
  end
  print "  "
  print fs.nlink

  user_id    = Process.uid
  user_name  = Etc.getpwuid(user_id).name
  group_id   = Process.gid
  group_name = Etc.getgrgid(group_id).name
  print "  "
  print user_name
  print "  "
  print group_name
  print "  "
  print fs.size
  print "  "
  print fs.mtime.month
  print " "
  print fs.mtime.mday
  print " "
  if fs.mtime.hour.to_s.size == 1
    print "0"
  end   
  print fs.mtime.hour
  print ":"
  if fs.mtime.min.to_s.size == 1
    print "0"
  end
  print fs.mtime.min
  print " "
  print fl
  print "\n"
end

