class Gizzard 
  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def erb_result(name, binding_object)
    html = File.read("views/#{name}.html") 
    template_regex = /<%[ =].+? %>/
    matches = html.scan(template_regex)
    matches.each do |match|
      if (match[2] == '=')
        eval(extract_code(match), binding_object)
      else
        html.sub!(match, eval(extract_code(match), binding_object))
      end
    end
    p html
    html
  end

  def extract_code(tag)
    captures = (/<%= (.+) %>/.match(tag) || /<% (.+) %>/.match(tag)).captures
    raise NotImplementedError if captures.size > 1
    captures[0]
  end
end
