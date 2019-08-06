require 'sinatra'
require 'sinatra/reloader'

require_relative 'cards'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

helpers do
  def num_terms(set_name)
    set_id = @set_names.index(set_name)
    cards = Cards.from_file("data/#{set_id}.txt")
    cards.size 
  end

  def highlight_matches(string, query)
    matches = string.scan(/#{query}/i).uniq
    matches.each do |match|
      string = string.gsub(match, "<mark>#{match}</mark>")
    end
    string
  end

  def match_or_matches(number)
    match_or_matches = number == 1 ? "match" : "matches"
  end

  def stylesheet_file_names
    Dir.glob('public/stylesheets/*.css').map do |filename|
      filename.match(/stylesheets\/([^.]+)/).captures[0]
    end
  end
end

def cards_matching(query)
  return [] if query.nil?

  matches = {}
  @set_names.each_with_index do |set_name, set_id|
    matches[set_name] = [] 
    cards = Cards.from_file("data/#{set_id}.txt")
    cards.each_with_index do |card|
      if /#{query}/i =~ card.join
        matches[set_name].push(card)
      end
    end
  end
  matches.select {|k, v| v.size > 0}
end

def set_names_matching(query)
  return [] if query.nil?
  @set_names.select {|name| /#{query}/i =~ name}
end

before do
  @stylesheets =  stylesheet_file_names
  @set_names = File.readlines('data/set_names.txt')
end

get '/' do
  @title = 'Sets' 
  erb :nav_sidebar do
    erb :home
  end
end

get '/search' do
  @query = params[:query]
  @matching_names = set_names_matching(@query)
  @matching_cards = cards_matching(@query)
  erb :nav_sidebar do
    erb :search_result
  end
end

get '/sets/new' do
  @title = 'Create a new set'
  erb :nav_sidebar do
    erb :new_set
  end
end

post '/sets' do
  session[:temp_set] = {name: params[:set_name],
                        cards: Cards.parse_text(params[:cards_text_box])} 
  redirect '/temp_set'
end

get '/temp_set' do
  @title = session[:temp_set][:name]
  @cards= session[:temp_set][:cards] 
  erb :nav_sidebar do
    erb :temp_set
  end
end

get '/sets/public/:set_id' do
  redirect not_found if (
    /[^\d]/ =~ params['set_id'])

  @set_id = params['set_id'].to_i

  redirect not_found unless (0...@set_names.size).cover?(@set_id)

  @cards = Cards.from_file("data/#{@set_id}.txt")
  @title = @set_names[@set_id] 
  erb :nav_sidebar do
    erb :set
  end
end

get '/sets/public/:set_id/flashcards' do
  redirect not_found if (
    /[^\d]/ =~ params['set_id'])
  redirect "/sets/public/#{params['set_id']}/flashcards/0/term" 
end

get '/sets/public/:set_id/flashcards/:card_id/:side' do
  redirect not_found if (
    /[^\d]/ =~ params['set_id'] || 
    /[^\d]/ =~ params['card_id'] ||
   !['term', 'definition'].include?(params[:side]))

  @set_id = params['set_id'].to_i
  @card_id = params['card_id'].to_i
  @side = params['side']

  puts "#{(0...@set_names.size).to_a}"
  redirect not_found unless (0...@set_names.size).cover?(@set_id)
    
  @cards = Cards.from_file("data/#{@set_id}.txt")
  redirect not_found unless (0...@cards.size).cover?(@card_id)

  if @side == 'term'
    @display = @cards[@card_id][0] 
    other_side = "definition"
  else
    @display = @cards[@card_id][1]
    other_side = "term"
  end

  link_prefix = "/sets/public/#{@set_id}/flashcards"

  if @card_id > 0
    @previous_card_link = "#{link_prefix}/#{@card_id - 1}/term" 
  end

  if @card_id < @cards.size - 2
    @next_card_link = "#{link_prefix}/#{@card_id + 1}/term" 
  end

  @flip_link = "#{link_prefix}/#{@card_id}/#{other_side}" 

  @title = @set_names[@set_id] 
  erb :nav_sidebar do
    erb :flashcards
  end
end

not_found do
  @title = '404'
  status 404
  erb :nav_sidebar do
    erb :not_found
  end
end
