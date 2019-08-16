# First Time Set-Up
1. Install the [Heroku Command Line Interface](https://toolbelt.heroku.com/). Login using `heroku login`.
2. Deploying to Heroku requires that a project is stored in a Git repository. Create a Git repository and commit all the project's files to it. 
3. Comment out `require 'sinatra/reloader'` or replace with `require 'sinatra/reloader' if development`.
4. Comment out `require 'pry'` everywhere that you have it.
5. Specify a Ruby version in Gemfile so that Heroku knows the exact version of Ruby to use when serving the project: `ruby '2.5.3'`. Run `bundle install`
6. Configure your application to use a production web server.
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
7. Create a file `Procfile` in the root of hte project. `web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}`
8. Run `heroku local` and navigate to `http://localhost:5000/` to test locally.
9. Run `heroku apps:create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git` to create a heroku app using the Ruby buildpack. You can give the app a name if you want, or heroku will generate one for you.
10. If you created an app already and forgot to add the ruby buildpack, you can do so with `heroku buildpacks:set https://github.com/heroku/heroku-buildpack-ruby.git`. 
11. Run `git push heroku master` to push the project to the Heroku application.
12. Visit the app to check that everything is working.

# Deploying Later Changes
1. Comment out `require 'sinatra/reloader'`.
2. Comment out `require 'pry'`.
3. Run `git push` to push to master.
4. Run `heroku local` and navigate to `http://localhost:5000/` to test locally.
5. Run `git push heroku master` to push the project to the Heroku application.
6. Visit the app to check that everything is working.

# Adding a postgresql database
1. In the `DatabasePersistence` class, use the following:
```
@connection = if Sinatra::Base.production?
        PG.connect(ENV['DATABASE_URL'])  
      else
        PG.connect(dbname: "todos") # name of your database
      end
```
This code uses the DATABSE_URL environment variable to determine the database name when running on heroku.
2. Enable postgresql, free tier ("hobby-dev" plan). 
`heroku addons:create heroku-postgresql:hobby-dev`
3. Set up schema.
`heroku pg:psql < schema.sql`
4. The free hobby-dev plan only allows for max 20 open database connections at once. If we exceed this limit, then our application will throw an error. Add the following code into your application to ensure that you don't exceed that 20 connection limit. 
Add to `codecards.rb`:
```
after do
  @storage.disconnect
end
```
Add to `database_persistence.rb`:
```
def disconnect
  @db.close
end
```
