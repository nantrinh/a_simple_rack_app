require 'pry'
require 'pg'

require_relative 'database_persistence'
require_relative 'cards'

db = DatabasePersistence.new 
user_id = db.user_id('public')
raise StandardError, 'public user does not exist' if user_id.nil?

# for all sets with titles listed in set_titles,
# insert the set title in "sets"
# tie it to the public user in "sets_users"
# insert all cards from the appropriate file to "cards"
set_titles = File.readlines('data/set_titles.txt')
set_titles.map! {|x| x.chomp}

set_titles.each do |title|
  db.create_set(title, user_id)
end

set_titles.each_with_index do |title, index|
  set_id = db.set_id(title, user_id)
  str = File.read("data/#{index}.txt") 
  cards = Cards.str_to_array(str)
  cards.each do |term, definition|
    db.create_card(term, definition, set_id)
  end
end

# HELPFUL STATEMENTS FOR DEBUGGING
# sql = 'select id, set_id, substring(term, 1, 20) as term, substring(definition, 1, 20) as def from cards limit 10;' 
# sql = 'select id, set_id, substring(term, length(term)-20) as term, substring(definition, length(definition) - 20) as def from cards limit 10;'
