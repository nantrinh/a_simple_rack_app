# A Simple Rack App: CodeCards

I followed [this 4-part tutorial](https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-1) from Launch School to learn how to make a simple app. I called it CodeCards. Then I tweaked it to explore a few features that I was not that familiar with.

I documented my work here to refer to when my future self inevitably forgets some details, and for anyone else who may be interested.

## Set Up Project
This part follows the Launch School tutorial closely.

Create a local folder, `a_simple_rack_app`. Make sure it is not nested inside of any other projects or applications.

We will be using Bundler to manage dependencies, and Bundler refers to a `Gemfile` to see what gems are required. 
Create a new file `Gemfile` in the folder, with the following contents:
```
source "https://rubygems.org"

gem 'rack', '~> 2.0.1'
```

Run `bundle install` to install dependencies and generate a `Gemfile.lock` file. According to the Launch School Core Ruby Tools [book](https://launchschool.com/books/core_ruby_tools/read/bundler#gemfile), `Gemfile.lock` shows all the dependencies for your program: the Gems listed in `Gemfile`, as well as any Gems that those depend on. 

Create a `config.ru` file with the following contents. This is a `rackup` file, a configuration file that Rack will use to know what to run and how to run it.
```ruby
require_relative 'codecards'

run CodeCards.new
```

Since we put `require_relative 'codecards'` in my rackup file, this implies that the main code for our app will be located in a file called `codecards.rb`.

# The App 
This part deviates from the Launch School tutorial.

Create a file `codecards.rb`. This is the app code I used.
