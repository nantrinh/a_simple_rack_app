# A Simple Rack App: CodeCards

I followed [this 4-part tutorial](https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-1) from Launch School to learn how to make a simple app. I called it CodeCards. Then I tweaked it to explore a few features that I was not that familiar with.

I documented my work here to refer to when my future self inevitably forgets some details, and for anyone else who may be interested.

## Preparations 
This part follows the Launch School tutorial closely.

1. Create a local folder, `a_simple_rack_app`. Make sure it is not nested inside of any other projects or applications.
**Why?** If you working within an existing project or application, their dependencies may interfere with yours. You would want to start off with a clean slate.

2. Create a new file `Gemfile` in the folder, with the following contents:
```
source "https://rubygems.org"

gem 'rack', '~> 2.0.1'
```
**Why?** I used Bundler to manage dependencies. Bundler refers to a `Gemfile` to see what gems are required. 


3. Run `bundle install` to install dependencies and generate a `Gemfile.lock` file.

**Why?** According to the Launch School Core Ruby Tools [book](https://launchschool.com/books/core_ruby_tools/read/bundler#gemfile), `Gemfile.lock` shows all the dependencies for your program: the Gems listed in `Gemfile`, as well as any Gems that those depend on. 

4. Create a `config.ru` file with the following contents.
```ruby
require_relative 'codecards'

run CodeCards.new
```
**Why?** This is a `rackup` file, a configuration file that Rack will use to know what to run and how to run it. Rack expects it to be called `config.ru` by default.


4. Create a file `codecards.rb`.
**Why?** Since I put `require_relative 'codecards'` in my rackup file, this implies that the main code for the app will be located in a file called `codecards.rb`.

# The App 
This part deviates from the Launch School tutorial.

