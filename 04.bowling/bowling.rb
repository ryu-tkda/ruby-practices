#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

# 文字列を整数に
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0 if shots.size < 18
  else
    shots << s.to_i
  end
end

# フレームごとに分ける
frames = shots.each_slice(2).to_a
if frames[10]
  frames[9].push(*frames[10])
  frames.pop(1)
end

# スコアの計算
point = 0

frames.each_with_index do |frame, i|
  point += if i < 8 && frame[0] == 10
             frames[i + 1][0] == 10 ? 20 + frames[i + 2][0] : 10 + (frames[i + 1]).sum
           elsif i == 8 && frame[0] == 10
             frames[i + 1][0] == 10 ? 20 + frames[i + 1][1] : 10 + frames[i + 1][0] + frames[i + 1][1]
           elsif i != 9 && frame.sum == 10
             10 + frames[i + 1][0]
           else
             frame.sum
           end
end
puts point
