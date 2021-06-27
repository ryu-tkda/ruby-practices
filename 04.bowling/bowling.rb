#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数を取得
# (,)区切りで配列に展開
score = ARGV[0]
scores = score.split(',')

# 文字列を整数に
shots = []
framebox = 0
scores.each do |s|
  if framebox >= 18
    if s == 'X'
      shots << 10q
      framebox += 1
      next
    end
  elsif s == 'X'
    shots << 10
    shots << 0
    framebox += 2
    next
  end
  shots << s.to_i
  framebox += 1
end

# フレームごとに分ける
frames = []
shots.each_slice(2) do |s|
  frames << s
end
unless (frames[10]).nil?
  frames[9].push(*frames[10])
  frames.pop(1)
end

# スコアの計算
point = 0

frames.each_with_index do |_frame, i|
  point += if frames[i][0] == 10 && i != 9 && i + 1 != 9
             if frames[i + 1][0] == 10 && i + 2 != 9
               20 + frames[i + 2][0]
             elsif frames[i + 2][0] == 10 && i + 2 == 9
               30
             elsif frames[i + 2][0] != 10 && i + 2 == 9
               20 + frames[i + 2][0]
             else
               10 + frames[i + 1][0] + frames[i + 1][1]
             end
           elsif frames[i][0] == 10 && i != 9 && i + 1 == 9
             10 + frames[i + 1][0] + frames[i + 1][1]
           elsif frames[i][0] != 10 && frames[i][0] + frames[i][1] == 10 && i != 9
             10 + frames[i + 1][0]
           elsif i == 9
             if frames[i][0] == 10
               if frames[i][1] == 10
                 20 + frames[i][2]
               else
                 10 + frames[i][1]
               end
             elsif frames[i][0] != 10 && frames[i][0] + frames[i][1] == 10
               10 + frames[i][2]
             else
               frames[i][0] + frames[i][1]
             end
           else
             frames[i][0] + frames[i][1]
           end
end
puts point

