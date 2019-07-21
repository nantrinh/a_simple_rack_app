require 'sinatra'
require 'sinatra/reloader'

require_relative 'cards'

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
end

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

get '/:user_id/:set_id' do
  @set_id = params['set_id'].to_i
  @user_id = params['user_id'].to_i

  redirect not_found unless @user_id.zero? && \
    (0...@set_names.size).cover?(@set_id)

  @cards = Cards.from_file("data/#{@set_id}.txt")
  @title = @set_names[@set_id] 
  erb :nav_sidebar do
    erb :set
  end
end

get '/:user_id/:set_id/flashcards' do |user_id, set_id|
  redirect "/#{user_id}/#{set_id}/flashcards/0/term" 
end

get '/:user_id/:set_id/flashcards/:card_id/:side' do
  @set_id = params['set_id'].to_i
  @user_id = params['user_id'].to_i
  @card_id = params['card_id'].to_i
  @side = params['side']

  redirect not_found unless @user_id.zero? && \
    (0...@set_names.size).cover?(@set_id) && \
    ['term', 'definition'].include?(@side)

  @cards = Cards.from_file("data/#{@set_id}.txt")
  redirect not_found unless (0...@cards.size).cover?(@card_id)

  if @side == 'term'
    @display = @cards[@card_id][0] 
    other_side = "definition"
  else
    @display = @cards[@card_id][1]
    other_side = "term"
  end

  link_prefix = "/#{@user_id}/#{@set_id}/flashcards"

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

def sets_matching(query)
  return [] if query.nil?

  matches = {}
  @set_names.each_with_index do |set_name, set_id|
    matches[set_name] = []
    cards = Cards.from_file("data/#{set_id}.txt")
    cards.each_with_index do |card|
      break if matches[set_name] == 5
      if Regexp.new(/#{query}/i) =~ card.join
        matches[set_name].push(card)
      end
    end
  end
  matches.select {|k, v| v.size > 0}
end

get '/search' do
  @query = params[:query]
  @matches = sets_matching(@query)
  # TODO
  # highlight matches in terms (use mark tag)
  # also search for sets and return set name if it's a match
  # highlight set name also if it's a match
  erb :nav_sidebar do
    erb :search_result
  end
end

not_found do
  @title = '404'
  status 404
  erb :nav_sidebar do
    erb :not_found
  end
end
