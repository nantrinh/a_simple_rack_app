require_relative 'text_formatters'

class Cards
  attr_reader :cards

  def self.str_to_array(str)
      str = sanitize(str)
      str.gsub!("\r", '')
      cards = str.split("\n\n# ").map{|card| card.split("\n---\n")}
      cards.each do |card|
        card.each do |term, definition|
          term.sub!(/^# /, '')
        end
      end
      cards.map do |card|
        card.map {|str| replace_spaces_with_nbsp_in_code_snippets(str)}
      end
      cards
  end

  def self.array_to_str
    '# ' + cards.map {|card| card.join("\n---\n")}.join("\n\n# ")
  end
end
