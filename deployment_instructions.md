1. Install the [Heroku Command Line Interface](https://toolbelt.heroku.com/). Login using `heroku login`.
2. Deploying to Heroku requires that a project is stored in a Git repository. Create a Git repository and commit all the project's files to it. 
3. Comment out `require 'sinatra/reloader'` or replace with `require 'sinatra/reloader' if development`. Comment out `require pry` everywhere that you have it.
4. Specify a Ruby version in Gemfile so that Heroku knows the exact version of Ruby to use when serving the project: `ruby '2.5.3'`. Run `bundle install`
5. Configure your application to use a production web server.
  - Add this to the Gemfile:
    ```
    group :production do
      gem "puma"
    end
    ```
  - Run `bundle install`.
  - Create a `config.ru` in the root of the project which tells the web server how to start the application.
    ```
    require "./codecards"
    run Sinatra::Application
    ```
6. Create a file `Procfile` in the root of hte project. `web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}`
7. Run `heroku local` and navigate to `http://localhost:5000/` to test locally.
8. Run `heroku apps:create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git` to create a heroku app using the Ruby buildpack. You can give the app a name if you want, or heroku will generate one for you.
9. If you created an app already and forgot to add the ruby buildpack, you can do so with `heroku buildpacks:set https://github.com/heroku/heroku-buildpack-ruby.git`. 
10. Run `git push heroku master` to push the project to the Heroku application.
11. Visit the app to check that everything is working.

