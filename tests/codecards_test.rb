ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
Minitest::Reporters.use!

require_relative '../codecards'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Create'
    assert_includes last_response.body, 'Sets'
  end

  def test_new_set_view
    get '/sets/new'
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Create a new set'
    assert_includes last_response.body, 'form'
  end

  def test_new_set_submission
    post '/sets', set_name: 'ABC123 Set', cards_text_box: "# sample text xyz\n---\nsample definition\n\n# another term lala\n---\nsome other definition"
    assert_equal 302, last_response.status
    get last_response['Location']
    assert_includes last_response.body, 'ABC123 Set'
    assert_includes last_response.body, 'sample text xyz'
    assert_includes last_response.body, 'lala'
    assert_includes last_response.body, 'table'
  end

  # def test_edit_set
  #   # only works if there is a set to edit
  #   get '/sets/temp_set/edit'
  #   assert_equal 200, last_response.status
  #   assert_includes last_response.body, 'Save'
  #   assert_includes last_response.body, 'form'
  # end

  def test_public_sets
    set_names = File.readlines('data/set_names.txt')
    set_names.each_with_index do |name, index|
      get "/sets/public/#{index}"
      assert_equal 200, last_response.status
      assert_includes last_response.body, name 
      assert_includes last_response.body, 'Study' 
      assert_includes last_response.body, 'table' 
    end
  end

  def test_flashcards 
    set_names = File.readlines('data/set_names.txt')
    set_names.each_with_index do |name, index|
      get "/sets/public/#{index}/flashcards"
      assert_equal 302, last_response.status
      get last_response['Location']

      assert_equal 200, last_response.status
      assert_includes last_response.body, 'FLIP' 
    end
  end

  def test_nonexistent_public_sets
    set_names = File.readlines('data/set_names.txt')
    get "/sets/public/#{set_names.size}/"
    assert_equal 404, last_response.status

    get '/sets/public/-1'
    assert_equal 404, last_response.status
  end
end
