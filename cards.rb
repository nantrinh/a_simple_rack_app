class Cards
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
end
