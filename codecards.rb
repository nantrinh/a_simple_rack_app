require_relative 'cards'
require_relative 'gizzard'

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
    else
      status = 404
      headers = { 'Content-Type' => 'text/html', 'Content-Length' => '48' }
      body = '<html><body><h4>404 Not Found</h4></body></html>'
    end
    response(status, headers, body)
  end
end
