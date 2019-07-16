require 'sinatra'
require 'sinatra/reloader'

require_relative 'cards'

before do
  @set_names = File.readlines('data/set_names.txt')
end

get '/' do
  @title = 'Sets' 
  erb :home
end

get '/random_card' do
  @term, @definition = Cards.new.random_card
  erb :random_card
end

get '/:user_id/:set_id' do |user_id, set_id|
  @nav_title = 'Sets'

  redirect not_found unless user_id.to_i.zero? && \
    (0...@set_names.size).cover?(set_id.to_i)

  @cards = Cards.from_file("data/#{set_id}.txt")
  @title = @set_names[set_id.to_i] 
  erb :nav_on_left do
    erb :set
  end
end

not_found do
  status 404
  '~~~~404~~~~'
end
