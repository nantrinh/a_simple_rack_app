require 'pry'
require 'pg'

require_relative 'database_persistence'

db = DatabasePersistence.new 
user_id = db.user_id('public')
raise StandardError, 'public user does not exist' if user_id.nil?

# for all sets with titles listed in set_titles,
# insert the set title in "sets"
# tie it to the public user in "sets_users"
# insert all cards from the appropriate file to "cards"
set_titles = File.readlines('data/set_titles.txt')

set_titles.each do |title|
  db.add_set(title.chomp)
  str = File.read("data/#{@set_id}.txt") 
  cards = Cards.str_to_array(str)
  binding.pry
  puts ""
end

