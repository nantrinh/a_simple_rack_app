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
   ```
   require_relative 'cards'
   
   class CodeCards 
     def call(env)
       case env['REQUEST_PATH']
       when '/'
         status = 200
         headers = {'Content-Type' => 'text/html'}
         body = "<html><body><h1>Hello World</h1></body></html>"
         response(status, headers, body)
       when '/random_card'
         term, definition = Cards.new.random_card
         status = 200
         headers = {'Content-Type' => 'text/html'}
         body = "<html><body><h2>#{term}</h2><p>#{definition}</p></body></html>"
         response(status, headers, body)
       else
         status = 404 
         headers = {'Content-Type' => 'text/html', 'Content-Length'=> '48'}
         body = "<html><body><h4>404 Not Found</h4></body></html>"
         response(status, headers, body)
       end
     end
   
     def response(status, headers={}, body='')
       [status, headers, [body]]
     end
   end
   ```
   > Every Rack app must respond to a `call` method with an array containing the status, headers, and body. The status should be a status code (String). The headers should be a hash in the style above, and the body should be an object that responds to the `each` method. Here, I use an array. Note that when the path is `'/random_card'`, the response is dynamically generated. I will move this to a template in a later step.


6. Create a file `cards.rb` with the following content.
   ```
   class Cards
     def initialize
      @cards = [
        ["What is the DOM (Document Object Model)?", "An in-memory object representation of an HTML document.\nA hierarchy of nodes.\nIt provides a way to interact with a web page using JavaScript and provides the functionality needed to build modern interactive user experiences."],
       ["Why do browsers insert elements into the DOM that are missing from the HTML?", "A fundamental tenet of the web is permissiveness. Browsers always do their best to display HTML, even when it has errors."],
       ["Are all text nodes the same?", "Yes. However, developers sometimes make a distinction between empty nodes (spaces, tabs, newlines, etc.) and text nodes that contain content (words, numbers, symbols, etc.)."]
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
   > Why? I do this so I do not have to type the long command every time I want to run the server. Note that you can choose whichever port you wish.

2. (Optional) Run this command to change the permissions for the file, marking it as executable.
   `chmod +x run.sh`

3. Run your server using this command if you have followed the optional steps above: `./run`, or, if you haven't, run `bundle exec rackup config.ru -p 9595`.

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
3. Replace the `body = "<html><body><h2>#{term}</h2><p>#{definition}</p></body></html>"` line with `body = File.read("views/random_card.html")`.
   > If you restart your server and navigate to `localhost:9595/random_card` now, you will see that the response is literally #{term} and #{definition}, which is not what we want to present. 


# WORK IN PROGRESS 
To this end, the tutorial makes use of [ERB](https://www.stuartellis.name/articles/erb/), which is part of the Ruby standard library. You do not need to install any other software to use it.

When I was following along with the tutorial, I got stumped when bindings were introduced. So I defined a few of my own functions to get a better idea of how ERB works.

ERB involves the use of particular syntax to serve as templates.
Tags with an equals sign indicate that the code inside is an expression, and the 

2. Extract the html from `codecards.rb`, each to their own `erb` files within `views`.
For example, `random_card.erb` should contain:
```

```
