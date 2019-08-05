require_relative 'text_formatters'
require 'pry'

class Cards
  attr_reader :cards

  def self.from_file(path_to_file)
    data = File.read(path_to_file)
    data = sanitize(data)
    data = (data)
    cards = data.split("\n\n# ").map{|card| card.split("\n---\n")}
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
end
