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
  @set_id = set_id.to_i
  @user_id = user_id.to_i

  redirect not_found unless @user_id.zero? && \
    (0...@set_names.size).cover?(@set_id)

  @cards = Cards.from_file("data/#{@set_id}.txt")
  @title = @set_names[@set_id] 
  erb :nav_sidebar do
    erb :set
  end
end

get '/:user_id/:set_id/flashcards' do |user_id, set_id|
  @set_id = set_id.to_i
  @user_id = user_id.to_i

  redirect not_found unless @user_id.zero? && \
    (0...@set_names.size).cover?(@set_id)

  @cards = Cards.from_file("data/#{@set_id}.txt")
  @title = @set_names[@set_id] 
  erb :nav_sidebar do
    erb :flashcards
  end
end

not_found do
  status 404
  '~~~~404~~~~'
end
