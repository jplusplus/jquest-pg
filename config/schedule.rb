require "whenever"

# Learn more: http://github.com/javan/whenever
every :day, :at => '4:00am' do
  rake "jquest_pg:images"
end
