**WARNING**: This project is unfinished.

# A Simple Rack App: CodeCards

I followed [this 4-part tutorial](https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-1) from Launch School to learn how to make a simple app. I called it CodeCards. Then I tweaked it to explore a few features that I was not that familiar with.

I documented my work here to refer to when my future self inevitably forgets some details, and for anyone else who may be interested.

## Preparations 
This part follows the Launch School tutorial closely.

### Set Up Files

1. Create a local folder, `a_simple_rack_app`. Make sure it is not nested inside of any other projects or applications.

   > Why? If you working within an existing project or application, their dependencies may interfere with yours. You would want to start off with a clean slate.

2. Create a new file `Gemfile` in the folder, with the following contents:
   ```
   source "https://rubygems.org"
   
   gem 'rack', '~> 2.0.1'
   ```
   > Why? I used Bundler to manage dependencies. Bundler refers to a `Gemfile` to see what gems are required. 

3. Run `bundle install` to install dependencies and generate a `Gemfile.lock` file.

   > Why? `Gemfile.lock` shows all the dependencies for your program: the Gems listed in `Gemfile`, as well as any Gems that those depend on. (Reference: [Launch School Core Ruby Tools](https://launchschool.com/books/core_ruby_tools/read/bundler#gemfile))

4. Create a `config.ru` file with the following contents.
   ```ruby
   require_relative 'codecards'
   
   run CodeCards.new
   ```

   > Why? This is a `rackup` file, a configuration file that Rack will use to know what to run and how to run it. Rack expects the file to be called `config.ru` by default.

4. Create a file `codecards.rb`.

   > Why? Since I put `require_relative 'codecards'` in my rackup file, this implies that the main code for the app will be located in a file called `codecards.rb`.

5. Put the following content inside `codecards.rb`.
   ```ruby
   require_relative 'cards'
   
   class CodeCards 
     def call(env)
       case env['REQUEST_PATH']
       when '/'
         status = 200
         headers = {'Content-Type' => 'text/html'}
         body = '<html><body><h1>Hello World</h1></body></html>'
       when '/random_card'
         term, definition = Cards.new.random_card
         status = 200
         headers = {'Content-Type' => 'text/html'}
         body = "<html><body><h2>#{term}</h2><p>#{definition}</p></body></html>"
       else
         status = 404 
         headers = {'Content-Type' => 'text/html', 'Content-Length'=> '48'}
         body = '<html><body><h4>404 Not Found</h4></body></html>'
       end
       response(status, headers, body)
     end
   
     def response(status, headers={}, body='')
       [status, headers, [body]]
     end
   end
   ```
   > Every Rack app must respond to a `call` method with an array containing the status, headers, and body. The status should be a status code (String). The headers should be a hash in the style above, and the body should be an object that responds to the `each` method. Here, I use an array. Note that when the path is `'/random_card'`, the response is dynamically generated. I will move this to a template in a later step.


6. Create a file `cards.rb` with the following content.
   ```ruby
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
   ```
   > The app relies on this file to return a random card. I define 3 cards here in an array of arrays format. I will use databases instead of hard-coding the cards into a file, in a later step.

### Run Your App 

1. (Optional) For Linux Users: Create a file `run.sh` with the following content.
   ```
   #!/bin/sh
   bundle exec rackup config.ru -p 9595
   ```
   > Why? I do this so I do not have to type the long command every time I want to run the app. Note that you can choose whichever port you wish.

2. (Optional) Run this command to change the permissions for the file, marking it as executable.
   `chmod +x run.sh`

3. Run your app using this command if you have followed the optional steps above: `./run`, or, if you haven't, run `bundle exec rackup config.ru -p 9595`.

4. If you are using [HTTPie](https://github.com/jakubroztocil/httpie), run `http GET localhost:9595/` in the terminal and view the response. It should look like:
   ```
   HTTP/1.1 200 OK
   Connection: Keep-Alive
   Content-Type: text/html
   Date: Sat, 06 Jul 2019 23:37:48 GMT
   Server: WEBrick/1.4.2 (Ruby/2.5.3/2018-10-18)
   Transfer-Encoding: chunked
   
   <html><body><h1>Hello World</h1></body></html>
   ```
   Run `http GET localhost:9595/random_card` a few times to test out the random card functionality.
   Run `http GET localhost:9595/badlink`, or some other URL that the app is not equipped to handle, to test out the 404 response.

   Feel free to navigate to those URLs using your browser to test out the responses as well.

# Introducing Templates 
This part deviates from the Launch School tutorial.

It is a bit unwieldy to have the HTML directly in the `codecards.rb` file. It would be more manageable to have the HTML files separate from the app code, especially if some HTML files grow to be quite large. However, how would we continue to generate dynamic HTML if the template code is in a different file from the app code? For example, currently, the `'/random_card'` branch uses string interpolation to insert the values for the term and the definition into the HTML string. How can we perform this interpolation when the template code will be contained in a different file?

One way to do this would be to use the same interpolation syntax in the template file to signify Ruby expressions. We can read in the file, use regex to identify the Ruby expressions, evaluate the expressions, and replace the interpolation syntax in the string with the result of those expressions. 

Let's try that first.

## Use Ruby String Interpolation Syntax
1. Create a `views` folder in your project folder.
2. Extract the HTML from the `'/random_card'` branch to a file `random_card.html`. Put the new file in the `views` folder. I used a skeleton file from http://htmlshell.com/. 
   ```html
   <!DOCTYPE html>
   <html>
     <head>
       <meta charset="UTF-8">
       <title>Random Card</title>
     </head>
     <body>
       <h2>#{term}</h2>
       <p>#{definition}</p>
     </body>
   </html>
   ```
3. Replace the `body = "<html><body><h2>#{term}</h2><p>#{definition}</p></body></html>"` line with `body = File.read('views/random_card.html')`.
   > If you restart your server and navigate to `localhost:9595/random_card` now, you will see that the response literally returns #{term} and #{definition} now, which is not what we want to present.

The `body` variable now points to one long string: `'<!DOCTYPE html>\n<html>\n  <head>\n    <meta charset=\"UTF-8\">\n    <title>title</title>\n  </head>\n  <body>\n    <h2>\#{term}</h2>\n    <p>\#{definition}</p>\n  </body>\n</html>\n'`. I fiddled around a bit in `irb` before arriving at a solution that uses regex to find the embedded Ruby, extract the code, evaluate it, and replace the code and its marker syntax (i.e., #{}) with the result of the evaluations. 

4. Update the `codecards.rb` to incorporate the new templating functionality.
   ```ruby
   require_relative 'cards'
   
   class CodeCards 
     def call(env)
       case env['REQUEST_PATH']
       when '/'
         status = 200
         headers = { 'Content-Type' => 'text/html' }
         body = '<html><body><h1>Hello World</h1></body></html>'
       when '/random_card'
         term, definition = Cards.new.random_card
         status = 200
         headers = { 'Content-Type' => 'text/html' }
         body = File.read('views/random_card.html') 
         template_regex = /#\{.+?\}/
         matches = body.scan(template_regex)
         matches.each do |match|
           body.sub!(match, eval(extract_expression(match)))
         end
       else
         status = 404 
         headers = { 'Content-Type' => 'text/html', 'Content-Length'=> '48' }
         body = '<html><body><h4>404 Not Found</h4></body></html>'
       end
       response(status, headers, body)
     end
   
     def response(status, headers={}, body='')
       [status, headers, [body]]
     end
   
     def extract_expression(enclosed_code)
       captures = /#\{(.+)\}/.match(enclosed_code).captures
       raise NotImplementedError if captures.size > 1
       captures[0]
     end
   end
   ```
   > Restart your server and navigate to the `'/random_card'` path. You should see a term and definition now, as intended.

It would be a good idea to extract the template-handling functionality to its own method, to keep the `call` method clean, and so we can reuse it if we wanted to generate dynamic HTML pages for other paths.

While we're at it, we could move the `response` and `extract_expression` methods as well. The tutorial does this in Part 4, creating a class called `Monroe` to serve as the framework. I called mine `Gizzard`, because my cat loves chicken gizzards.

5. Create a file `gizzard.rb` with the following contents.
   ```ruby
   class Gizzard 
     def response(status, headers={}, body='')
       [status, headers, [body]]
     end
   
     def erb_result(name)
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
   ```

   `codecards.rb` should now look like the following.
   ```ruby
   require_relative 'cards'
   require_relative 'gizzard'
   
   class CodeCards < Gizzard
     def call(env)
       case env['REQUEST_PATH']
       when '/'
         status = 200
         headers = { 'Content-Type' => 'text/html' }
         body = '<html><body><h1>Hello World</h1></body></html>'
       when '/random_card'
         term, definition = Cards.new.random_card
         status = 200
         headers = { 'Content-Type' => 'text/html' }
         binding_object = binding
         body = erb_result(:random_card, binding_object)
       else
         status = 404
         headers = { 'Content-Type' => 'text/html', 'Content-Length' => '48' }
         body = '<html><body><h4>404 Not Found</h4></body></html>'
       end
       response(status, headers, body)
     end
   end
   ```
   Note the addition of the lines referencing `binding` and `binding_object`. If we did not use bindings, our code would throw an error, because the variables `term` and `definition` will not be in scope in the `gizzard.rb` file.

   > Why? An instance of `Binding` encapsulates the local variable bindings in effect at a given point in execution. A top-level method called `binding` returns whatever the current binding is. The most common use of `Binding` objects is in the position of second argument to `eval`. If you provide a binding in that position, the string being `eval`-ed is executed in the context of the given binding. Any local variables used inside the `eval` string are interpreted in the context of that binding. (Reference: David Black's The Well-Grounded Rubyist 2E (2014), Manning, page 434)

## Use ERB

The next thing I would like to do is to display several sets of cards on the website. For simplicity, I would start with sets that I have created and stored on my computer. I will work on allowing user input later.

How should I go about this given the current set of tools? Imagine I have three sets (e.g., one for Ruby syntax, one for JavaScript syntax, and one for the DOM). One way would be to create a template for each set. In the app code, I would add the functionality to handle 3 paths, each one leading to a different set. For a given set, I would read the data in from a file, and parse it in a format `cards = [[term, definition], [term, definition], ...]`. I would have a separate template for each set, explicitly written to display the exact number of cards per set. The nth term would be selected as `cards[n][0]`, and the nth definition would be selected as `cards[n][1]`.

This would work, but it would be tedious to create a template for each set, and difficult to maintain. Also, there is much duplication of work, because the template for each set would look very similar, varying only in the number of cards each template is designed to handle. Ideally we would be able to have one template for the purpose of displaying all cards in a set, and the template would loop through each subarray in the array of cards, generating html to display each term and definition in turn.

Right now the `erb_result` method in the `Gizzard` framework evaluates embedded code and inserts the result of each evaluation where the embedded code once was. I do not think it is possible to use `each` with an array of cards to achieve the desired result, without much modification that would complicate the code.

[ERB](https://ruby-doc.org/stdlib-2.6.3/libdoc/erb/rdoc/ERB.html) uses the syntax as displayed below (among others) to distinguish between code that it will evaluate only, and code that it will evaluate AND replace with the result. 
```
<% Ruby code -- inline with output %>
<%= Ruby expression -- replace with result %>
```
I will switch to using the ERB engine at this point.
[Part 3 of the LS tutorial](https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-3) covers ERB as well.

The files now look like the following:

`gizzard.rb`
```ruby
require 'erb'

class Gizzard 
  def response(status, headers={}, body='')
    [status, headers, [body]]
  end

  def erb(name, binding_object)
    ERB.new(File.read("views/#{name}.rhtml")).result(binding_object)
  end
end
```

`codecards.rb`
```ruby
require_relative 'cards'
require_relative 'gizzard'

class CodeCards < Gizzard
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      body = '<html><body><h1>Hello World</h1></body></html>'
    when '/random_card'
      term, definition = Cards.new.random_card
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      binding_object = binding
      body = erb(:random_card, binding_object)
    when '/0/0'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      cards = Cards.from_file('data/temp.txt')
      binding_object = binding
      body = erb(:set, binding_object)
    else
      status = 404
      headers = { 'Content-Type' => 'text/html', 'Content-Length' => '48' }
      body = '<html><body><h4>404 Not Found</h4></body></html>'
    end
    response(status, headers, body)
  end
end
```

`temp.txt`
```
# What is the DOM (Document Object Model)?
---
An in-memory object representation of an HTML document.
A hierarchy of nodes.
It provides a way to interact with a web page using JavaScript and provides the functionality needed to build modern interactive user experiences.

# Why do browsers insert elements into the DOM that are missing from the HTML?
---
A fundamental tenet of the web is permissiveness. Browsers always do their best to display HTML, even when it has errors.

# Are all text nodes the same?
---
Yes. However, developers sometimes make a distinction between empty nodes (spaces, tabs, newlines, etc.) and text nodes that contain content (words, numbers, symbols, etc.).

# Are empty nodes reflected visually in the browser?
---
No, but they are in the DOM, so do not neglect them.

# True or False: there is a direct one-to-one mapping between the tags that appear in an HTML file and the nodes in the DOM.
---
False. The browser may insert nodes that don't appear in the HTML due to invalid markup or the omission of optional tags. Text, including whitespace, also creates nodes that don't map to tags.

# Does this JavaScript run?
---
alert('Hello world!');
```

`random_card.rhtml`
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Random Card</title>
  </head>
  <body>
    <h2><%= term %></h2>
    <p><%= definition %></p>
  </body>
</html>
```

`set.rhtml`
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Set</title>
  </head>
  <body>
    <dl>
    <% cards.each do |term, definition| %>
      <dt><%= term %></dt>
      <dd><%= definition %></dd>
    <% end %>
    </dl>
  </body>
</html>
```

# Add More Sets
I added two more sets and titles for each of them.
The sets are located here:
- [`0.txt`](https://github.com/nantrinh/a_simple_rack_app/blob/8a0a0661e7201f3d402dc231ebbef389ba109e11/data/0.txt)
- [`1.txt`](https://github.com/nantrinh/a_simple_rack_app/blob/8a0a0661e7201f3d402dc231ebbef389ba109e11/data/1.txt)
- [`2.txt`](https://github.com/nantrinh/a_simple_rack_app/blob/8a0a0661e7201f3d402dc231ebbef389ba109e11/data/2.txt)

Updated `codecards.rb`:
```ruby
require_relative 'cards'
require_relative 'gizzard'

class CodeCards < Gizzard
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      body = '<html><body><h1>Hello World</h1></body></html>'
    when '/random_card'
      term, definition = Cards.new.random_card
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      binding_object = binding
      body = erb(:random_card, binding_object)
    when '/0/0'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      cards = Cards.from_file('data/0.txt')
      title = 'The DOM'
      binding_object = binding
      body = erb(:set, binding_object)
    when '/0/1'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      title = 'APIs'
      cards = Cards.from_file('data/1.txt')
      binding_object = binding
      body = erb(:set, binding_object)
    when '/0/2'
      status = 200
      headers = { 'Content-Type' => 'text/html' }
      title = 'Core Ruby Tools'
      cards = Cards.from_file('data/2.txt')
      binding_object = binding
      body = erb(:set, binding_object)
    else
      status = 404
      headers = { 'Content-Type' => 'text/html', 'Content-Length' => '48' }
      body = '<html><body><h4>404 Not Found</h4></body></html>'
    end
    response(status, headers, body)
  end
end
```

Updated `set.rhtml`:
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title><%= title %></title>
  </head>
  <body>
    <h1><%= title %></h1>
    <dl>
    <% cards.each do |term, definition| %>
      <dt><%= term %></dt>
      <dd><%= definition %></dd>
    <% end %>
    </dl>
  </body>
</html>
```

# Use Sinatra
There is now substantial repetition in the codecards file for the paths pertaining to the paths.

Let's switch to using the Sinatra framework since it has nice syntax for handling routes.

# Detailed TODO 
- Continue with Launch School web development course
- Make a flashcards template and enable flipping cards -- do it through links first then use javascript??
- Use database
- Allow user to input cards
- Allow user to import their cards (from text file)
- Allow user to download cards from quizlet

# Workflow Optimization TODO
- HTML style checkers, CSS style checkers
- Automate rubocop?

# TODO
- allow user to view all cards by set (e.g., quizlet.com/user/set)
    - your "database" are files in your directory for now
- allow user to learn cards by set (e.g., quizlet.com/user/set/flashcards/1)
    - implement with navigation done through links
