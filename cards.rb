class Cards
  attr_reader :cards

  def initialize
    @cards = [
      ['What is the DOM (Document Object Model)?', "An in-memory object representation of an HTML document.\nA hierarchy of nodes.\nIt provides a way to interact with a web page using JavaScript and provides the functionality needed to build modern interactive user experiences."],
      ['Why do browsers insert elements into the DOM that are missing from the HTML?', 'A fundamental tenet of the web is permissiveness. Browsers always do their best to display HTML, even when it has errors.'],
      ['Are all text nodes the same?', 'Yes. However, developers sometimes make a distinction between empty nodes (spaces, tabs, newlines, etc.) and text nodes that contain content (words, numbers, symbols, etc.).']
    ]
  end

  def random_card
    @cards.sample
  end

  def self.from_file(path_to_file)
    data = File.read(path_to_file)
    cards = data.split("\n\n# ").map{|card| card.split("\n---\n")}
    cards.each do |card|
      card.each do |term, _|
        term.sub!(/^# /, '')
      end
    end
    cards
  end
end
