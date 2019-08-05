require_relative 'sanitize'

class Cards
  attr_reader :cards

  def self.from_file(path_to_file)
    data = File.read(path_to_file)
    data = sanitize(data)
    cards = data.split("\n\n# ").map{|card| card.split("\n---\n")}
    cards.each do |card|
      card.each do |term, _|
        term.sub!(/^# /, '')
      end
    end
    cards
  end
end
