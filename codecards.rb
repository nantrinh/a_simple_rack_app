require 'sinatra'
require_relative 'cards'

def response(status, headers={}, body='')
  [status, headers, [body]]
end

get '/' do
  @title = 'Sets' 
  @set_names = File.readlines('data/set_names.txt')
  erb :home
end

get '/random_card' do
  @term, @definition = Cards.new.random_card
  erb :random_card
end

get '/:user_id/:set_id' do |user_id, set_id|
  @nav_title = 'Sets'
  @set_names = File.readlines('data/set_names.txt')

  redirect not_found unless user_id.to_i.zero? && \
    (0...@set_names.size).cover?(set_id.to_i)

  @cards = Cards.from_file("data/#{set_id}.txt")
  @title = @set_names[set_id.to_i] 
  erb :set
end

not_found do
  status 404
  '~~~~404~~~~'
end
