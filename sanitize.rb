def sanitize(str)
  str.gsub!('<', '&lt;')
  str.gsub!('>', '&gt;')
  str
end
