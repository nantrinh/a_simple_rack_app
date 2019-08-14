require 'pg'
require_relative 'database_persistence'
require 'pry'

connection = PG.connect(dbname: 'codecards')
db = DatabasePersistence.new

# Test creation and retrieval of user ids
user_id = db.user_id('public')
p user_id == '1'
p db.user_id('hello') == nil

data = {
  'nicki_minaj': ['megatron', 'no frauds', 'majesty'],
  'lee_hi': ['no one'],
  'bobby': ['tendae', 'holup!']
}

data.each do |username, set_titles|
#  db.add_user(username)
  user_id = db.user_id(username)
  set_titles.each do |title|
    # db.add_set(title, user_id)
    puts "set id of #{title} is #{db.set_id(title, user_id)}"
  end
end

#binding.pry
#puts ""
