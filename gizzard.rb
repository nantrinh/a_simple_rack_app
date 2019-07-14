require 'erb'

class Gizzard 
  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def erb(name, binding_object)
    ERB.new(File.read("views/#{name}.rhtml")).result(binding_object)
  end
end
