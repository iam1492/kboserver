# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron.log"

every 6.hours do
  rake 'fetch_chart'
end

every 1.day do
  rake 'fetch_schedule'
end

every 3.minutes do
  rake 'fetch_score'
end

every :day, :at => '4:00am' do
  rake 'fetch_report'
end

every :day, :at => '4:05am' do
  rake 'fetch_batter_total_rank'
end

every :day, :at => '4:10am' do
  rake 'fetch_pitcher_total_rank'
end

every :day, :at => '4:15am' do
  rake 'fetch_batter_rank'
end

every :day, :at => '4:20am' do
  rake 'fetch_pitcher_rank'
end

every :day, :at => '4:25am' do
  rake 'fetch_team_info'
end
