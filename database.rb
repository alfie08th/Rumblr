# Based on http://www.jonathanleighton.com/articles/2011/awesome-active-record-bug-reports/

# Run this script with `bundle exec ruby app.rb`
require 'sqlite3'
require 'active_record'
require 'time'

#require classes
require './models/post.rb'
require './models/user.rb'
require './models/comment.rb'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/bakery.db'
)

binding.pry
#

noww = Time.now

# timenow = Time.now
# timeThen = Time.now/then

# if seconds equal 24 hours or more, 1 day, 42 hours, 2day....
#   less than 24 hours 1 hour, 2 hours, 3 hours,
#   less than a hour, 1 min, 2 min, 3 migrations
#
# sec = ('1379844601000'.to_f / 1000).to_s
# Date.strptime(sec, '%s')
# //Sun, 22 Sep 2013
