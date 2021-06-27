
require "date"
require "optparse"
day = Date.today
# コマンドの作成
options = ARGV.getopts("y:","m:")
# yに指定があればy年、なければ今年
if options["y"]
  year = options["y"].to_i
else
  year = day.year
end
# mに指定があればm月、なければ今月
if options["m"]
  mon = options["m"].to_i
else
  mon = day.mon
end

wday = Date.new(year,mon,1).wday
lastday = Date.new(year,mon,-1).day
weeks = ["日","月","火","水","木","金","土"]

puts "      #{mon}月 #{year}"
puts weeks.join(" ")
print "   " * wday
(1..lastday).each do |day|
  print day.to_s.rjust(2) + " "
  wday += 1
  if wday % 7 == 0
    print "\n"
  end
end
if wday % 7 != 0
  print "\n"  
end
