require_relative 'cards'

class CodeCards 
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = "<html><body><h1>Hello World</h1></body></html>"
      response(status, headers, body)
    when '/random_card'
      term, definition = Cards.new.random_card
      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = File.read("views/random_card.html") 
      template_regex = /#\{.+?\}/
      matches = body.scan(template_regex)
      matches.each do |match|
        body.sub!(match, eval(extract_expression(match)))
      end
      response(status, headers, body)
    else
      status = 404 
      headers = {'Content-Type' => 'text/html', 'Content-Length'=> '48'}
      body = "<html><body><h4>404 Not Found</h4></body></html>"
      response(status, headers, body)
    end
  end

  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def extract_expression(enclosed_code)
    captures = /#\{(.+)\}/.match(enclosed_code).captures
    raise NotImplementedError if captures.size > 1
    captures[0]
  end
end
