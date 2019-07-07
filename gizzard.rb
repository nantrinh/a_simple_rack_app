class Gizzard 
  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def erb_result(name, binding_object)
    html = File.read("views/#{name}.html") 
    template_regex = /#\{.+?\}/
    matches = html.scan(template_regex)
    matches.each do |match|
      html.sub!(match, eval(extract_expression(match), binding_object))
    end
    html
  end

  def extract_expression(enclosed_code)
    captures = /#\{(.+)\}/.match(enclosed_code).captures
    raise NotImplementedError if captures.size > 1
    captures[0]
  end
end
