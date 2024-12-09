#!/usr/bin/env ruby

#
# Prints my stats as a CSV.
#
#     ./stats.rb > stats.csv
# or
#     ./stats.rb | tee stats.csv
#

# https://adventofcode.com/2024/stats
overall_stats = '''
 8   43839   2400  **********
 7   55905   2952  ************
 6   57712  20663  ***************
 5   81059  10409  ******************
 4  100740   8480  *********************
 3  127487  13394  ***************************
 2  141952  34692  **********************************
 1  201537  14172  *****************************************
'''.lines
   .map(&:chomp)
   .reject {|line| line.empty?}
   .map(&:split)
   .map {|row| row[0..2]}
   .map {|row| row.map(&:to_i)}
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
   .map do |row|
      day = row[0]
      my_first_puzzle_rank = row[1]
      total_first_puzzle = overall_stats[day][:finished_first_puzzle]
      my_second_puzzle_rank = row[2]
      total_second_puzzle = overall_stats[day][:finished_second_puzzle]
      [
        day,
        '',
        my_first_puzzle_rank,
        total_first_puzzle,
        ((1.0 - (my_first_puzzle_rank.to_f / total_first_puzzle)) * 100).to_i,
        '',
        my_second_puzzle_rank,
        total_second_puzzle,
        ((1.0 - (my_second_puzzle_rank.to_f / total_second_puzzle)) * 100).to_i,
      ]
   end

puts "Day,,Part 1 Rank,Part 1 Total,Part 1 Percentile,,Part 2 Rank,Part 2 Total,Part 2 Percentile"
personal_times.each do |row|
  puts row.join(',')
end
