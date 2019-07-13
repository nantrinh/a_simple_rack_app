require_relative 'cards'
require_relative 'gizzard'

require 'pry'

class CodeCards < Gizzard
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      body = '<html><body><h1>Hello World</h1></body></html>'
    when '/random_card'
      term, definition = Cards.new.random_card
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      binding_object = binding
      body = erb_result(:random_card, binding_object)
    when '/0/0'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      # todo: replace with something that reads in entire flashcards file 
      cards = Cards.new.cards
      # todo: render an html page that displays each term and definition
      binding_object = binding
      erb_result(:cards, binding_object)
    else
      status = 404
      headers = { 'Content-Type' => 'text/html', 'Content-Length' => '48' }
      body = '<html><body><h4>404 Not Found</h4></body></html>'
    end
    response(status, headers, body)
  end
end

data = File.read('data/1.txt')
cards = data.split("\n\n# ").map{|card| card.split("\n---\n")}
cards.each do |card|
  card.each do |term, _|
    term.sub!(/^# /, '')
  end
end

binding.pry
puts ''
