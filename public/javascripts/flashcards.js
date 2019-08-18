document.addEventListener("DOMContentLoaded", function() {
  var content = document.getElementById("content");
  var card = content.children[0]
  var term = card.children[0];
  var definition = card.children[1];

  var flip_button = document.getElementById("flip");
  var prev_button = document.getElementById("prev");
  var next_button = document.getElementById("next");

  term.classList.toggle('hide');

  document.addEventListener("keyup", function(e) {
    if (e.key.match(/^( |ArrowUp|ArrowDown)$/)) {
      flip();
    } else if (e.key === "ArrowRight" && card.nextElementSibling !== null) {
      next(); 
    } else if (e.key === "ArrowLeft" && card.previousElementSibling !== null) {
      prev(); 
    }
  });

  // FLIP
  content.addEventListener("click", flip);

  flip_button.addEventListener("click", function(e) {
    e.preventDefault(); 
    flip();
  });

  // ADVANCE TO NEXT CARD
  document.getElementById("next").addEventListener("click", function(e) {
    e.preventDefault(); 
    next();
  });

  // GO BACK TO PREVIOUS CARD
  document.getElementById("prev").addEventListener("click", function(e) {
    e.preventDefault(); 
    prev();
  });

  // FUNCTIONS
  function flip() {
    term.classList.toggle("hide");
    definition.classList.toggle("hide");
  }

  function next() {
    hide_current_content();
    card = card.nextElementSibling; 
    update_term_and_definition()
    term.classList.remove("hide");
    show_or_hide_prev_and_next()
  }

  function prev() {
    hide_current_content();
    card = card.previousElementSibling; 
    update_term_and_definition()
    term.classList.remove("hide");
    show_or_hide_prev_and_next()
  }

  function hide_current_content() {
    term.classList.add("hide");
    definition.classList.add("hide");
  }

  function update_term_and_definition() {
    term = card.children[0];
    definition = card.children[1];
  }

  function show_or_hide_prev_and_next() {
    if (card.previousElementSibling !== null) {
      prev_button.classList.remove("invisible"); 
    } else {
      prev_button.classList.add("invisible"); 
    }
    if (card.nextElementSibling !== null) {
      next_button.classList.remove("invisible"); 
    } else {
      next_button.classList.add("invisible"); 
    }
  }
});

