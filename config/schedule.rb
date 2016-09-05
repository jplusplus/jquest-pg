require "whenever"

# Learn more: http://github.com/javan/whenever
every :day, :at => '11:03am' do
  rake "jquest_pg:images"
end
