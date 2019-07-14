class Gizzard 
  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def erb_result(name, binding_object)
    html = File.read("views/#{name}.rhtml") 
    template_regex = /<%[ =].+? %>/
    matches = html.scan(template_regex)
    p matches
#    p matches.map {|x| eval(extract_code(x), binding_object)}
    matches.each do |match|
      if (match[2] == '=')
        html.sub!(match, eval(extract_code(match), binding_object))
      else
        eval(extract_code(match), binding_object)
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
