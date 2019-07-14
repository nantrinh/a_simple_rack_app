require 'sinatra'
require_relative 'cards'

def response(status, headers={}, body='')
  [status, headers, [body]]
end

def titles(index)
  ['The DOM', 'APIs', 'Core Ruby Tools'][index]
end

get '/' do
  status = 200
  headers = { 'Content-Type' => 'text/html' }
  body = '<html><body><h1>Hello World</h1></body></html>'
end

get '/random_card' do
  @term, @definition = Cards.new.random_card
  status = 200
  headers = { 'Content-Type' => 'text/html' }
  erb :random_card
end

get '/:user_id/:set_id' do |user_id, set_id|
  redirect not_found unless user_id.to_i.zero? && [0, 1, 2].include?(set_id.to_i)
  @cards = Cards.from_file("data/#{set_id}.txt")
  @title = titles(set_id.to_i) 
  erb :set
end

not_found do
  status 404
  '~~~~404~~~~'
end
