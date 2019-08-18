require 'sinatra'

require_relative 'database_persistence'
require_relative 'text_formatters'

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

configure(:development) do
  require 'pry'
  require 'sinatra/reloader'
  also_reload 'database_persistence.rb'
end

helpers do
  def highlight_matches(string, query)
    matches = string.scan(/#{query}/i).uniq
    matches.each do |match|
      string = string.gsub(match, "<mark>#{match}</mark>")
    end
    string
  end

  def plural?(string, count)
    count.to_i == 1 ? string : string + 's'
  end

  def stylesheet_file_names
    Dir.glob('public/stylesheets/*.css').map do |filename|
      filename.match(/stylesheets\/([^.]+)/).captures[0]
    end
  end

end

before do
  @stylesheets =  stylesheet_file_names
  @storage = DatabasePersistence.new
  @set_titles = @storage.set_titles
end

get '/' do
  @title = 'Sets' 
  erb :nav_sidebar do
    erb :home
  end
end

get '/search' do
  @query = params[:query]
  @matching_titles = @storage.set_titles_matching(@query) || []
  @matching_cards, @card_count  = @storage.cards_matching(@query) || []
  erb :nav_sidebar do
    erb :search_result
  end
end
# 
# get '/sets/new' do
#   @title = 'Create a new set'
#   erb :nav_sidebar do
#     erb :new_set
#   end
# end
# 
# post '/sets' do
#   session[:temp_set] = {name: params[:set_name],
#                         cards: Cards.parse_text(params[:cards_text_box])} 
#   redirect '/temp_set'
# end
# 
# get '/temp_set' do
#   @title = session[:temp_set][:name]
#   @cards = session[:temp_set][:cards] 
#   erb :nav_sidebar do
#     erb :temp_set
#   end
# end
# 
# get '/sets/temp_set/edit' do
#   @title = session[:temp_set][:name]
#   @cards = cards_array_to_str(session[:temp_set][:cards])
#   erb :nav_sidebar do
#     erb :edit_set
#   end
# end

get '/sets/:username/:url_title' do |username, url_title|
  user_id = @storage.user_id(username)
  set_id = @storage.set_id(url_title, user_id)

  redirect not_found if user_id.nil? || set_id.nil?

  @display_title = @storage.display_title(set_id, user_id)
  @cards = @storage.cards(set_id)
  @username = username
  @url_title = url_title
  erb :nav_sidebar do
    erb :set
  end
end

get '/sets/:username/:url_title/flashcards' do
  user_id = @storage.user_id(params[:username])
  set_id = @storage.set_id(params[:url_title], user_id)
  p user_id, set_id

  redirect not_found if user_id.nil? || set_id.nil?
  p user_id, set_id

  @cards = @storage.cards(set_id)

  redirect not_found if @cards.empty?

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

after do
  @storage.disconnect
end
