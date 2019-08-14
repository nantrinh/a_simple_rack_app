def sanitize(str)
  str.gsub!('<', '&lt;')
  str.gsub!('>', '&gt;')
  str
end

def replace_spaces_with_nbsp_in_code_snippets(str)
  template = /`[^`]+?`/
  matches = str.scan(template)
  matches.each do |match|
    edited = match.gsub(' ', '&nbsp;')
    str.gsub!(match, edited)
  end
  str
end

def urlize(str)
  str = str.downcase.gsub(/[^a-z0-9 ]/, '').gsub(/ +/, '-') 
end
