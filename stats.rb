#!/usr/bin/env ruby

#
# Prints my stats as a CSV.
#
#     ./stats.rb > stats.csv
# or
#     ./stats.rb | tee stats.csv
#
# It can fetch the overall stats from adventofcode.com, since they are public
# data.  But getting personal times requires authentication.  I don't know how
# to do that, so I copy my stats in this script as they become available.
#

require 'net/http'

STATS_REGEX = %r{<a href="/2024/day/\d+">\s*(?<day>\d+)\s+<span class="stats-both">\s*(?<both>\d+)</span>\s*<span class="stats-firstonly">\s*(?<firstonly>\d+)</span>}

uri = URI.parse('https://adventofcode.com/2024/stats')
response = Net::HTTP.get_response(uri)
overall_stats = response.body
                        .lines
                        .map { |line| STATS_REGEX.match(line) }.compact
                        .map { |match| match[1..] }
                        .map { |row| row.map(&:to_i) }
                        .reduce([]) do |memo, row|
                          day = row[0]
                          first_and_second_puzzles = row[1]
                          first_puzzle_only = row[2]
                          memo[day] = {
                            finished_first_puzzle: first_and_second_puzzles + first_puzzle_only,
                            finished_second_puzzle: first_and_second_puzzles,
                          }
                          memo
                        end

# https://adventofcode.com/2024/leaderboard/self
personal_times = '''
 18   01:46:03    6772      0   02:30:39   7318      0
 17   01:30:13    5932      0          -      -      -
 16   08:32:13   13539      0   13:45:57  13062      0
 15   01:18:21    5806      0   02:56:57   4319      0
 14   00:50:25    5423      0   02:03:36   5686      0
 13   01:46:43    8352      0   01:56:43   5392      0
 12   02:10:03    9939      0   05:58:52   9622      0
 11   01:45:52   12897      0   02:55:24  10107      0
 10   13:44:37   34717      0   13:50:59  33627      0
  9   10:58:59   32764      0   12:01:24  23435      0
  8   11:55:12   35875      0   12:32:25  34046      0
  7   12:26:35   39538      0   12:37:46  36628      0
  6   10:18:48   44271      0   11:14:52  27499      0
  5   15:34:14   61170      0   17:02:23  54206      0
  4   04:59:46   31579      0   05:14:54  26847      0
  3   08:44:00   60274      0   09:42:38  53287      0
  2   08:58:05   61493      0   09:28:22  44660      0
  1   21:55:06  104725      0   22:04:35  98763      0
'''.lines
   .map(&:chomp)
   .reject {|line| line.empty?}
   .map(&:split)
   .map {|row| [row[0], row[2], row[5]]}
   .map {|row| row.map(&:to_i)}
   .map do |day, my_first_puzzle_rank, my_second_puzzle_rank|
      total_first_puzzle = overall_stats[day][:finished_first_puzzle]
      total_second_puzzle = overall_stats[day][:finished_second_puzzle]
      [
        day,
        '',
        my_first_puzzle_rank,
        total_first_puzzle,
        ((1.0 - (my_first_puzzle_rank.to_f / total_first_puzzle)) * 100).to_i,
        '',
        my_second_puzzle_rank.positive? ? my_second_puzzle_rank : '',
        total_second_puzzle,
        my_second_puzzle_rank.positive? ? ((1.0 - (my_second_puzzle_rank.to_f / total_second_puzzle)) * 100).to_i : '',
      ]
   end

puts "Day,,Part 1 Rank,Part 1 Total,Part 1 Percentile,,Part 2 Rank,Part 2 Total,Part 2 Percentile"
personal_times.each do |row|
  puts row.join(',')
end
