#!/usr/bin/env ruby

#
# Prints my stats as a CSV
#
#     ./stats.rb > stats.csv
#

# https://adventofcode.com/2024/stats
overall_stats = '''
 1  98971  6280  *****************************************
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
      total_first_puzzle = overall_stats[row[0]][:finished_first_puzzle]
      my_second_puzzle_rank = row[2]
      total_second_puzzle = overall_stats[row[0]][:finished_second_puzzle]
      [
        day,
        '',
        my_first_puzzle_rank,
        total_first_puzzle,
        (my_first_puzzle_rank.to_f / total_first_puzzle).round(3),
        '',
        my_second_puzzle_rank,
        total_second_puzzle,
        (my_second_puzzle_rank.to_f / total_second_puzzle).round(3),
      ]
   end

puts "Day,,Part 1 Rank,Part 1 Total,Part 1 Percentile,,Part 2 Rank,Part 2 Total,Part 2 Percentile"
personal_times.each do |row|
  puts row.join(',')
end
