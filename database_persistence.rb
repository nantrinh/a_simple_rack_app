# require 'pry'
require 'pg'
require 'sinatra'

class DatabasePersistence
  def initialize
    if Sinatra::Base.production?
      @connection = PG.connect(ENV['DATABASE_URL'])
    else
      @connection = PG.connect(dbname: 'codecards')
    end
  end

  # CREATE (INSERT)
  def create_set(display_title, url_title, user_id)
    sql = 'INSERT INTO sets (display_title, url_title, user_id) VALUES ($1, $2, $3);'
    @connection.exec_params(sql, [display_title, url_title, user_id])
  end
  
  def create_user(name)
    sql = 'INSERT INTO users (name) VALUES ($1);'
    @connection.exec_params(sql, [name])
  end

  def create_card(term, definition, set_id)
    sql = 'INSERT INTO cards (term, definition, set_id) VALUES ($1, $2, $3);'
    @connection.exec_params(sql, [term, definition, set_id])
  end

  # READ (SELECT)
  def user_id(name)
    sql = 'SELECT id FROM users WHERE name = $1;'
    result = @connection.exec_params(sql, [name])
    result[0]['id'] unless result.ntuples.zero?
  end

  def set_id(url_title, user_id)
    sql = 'SELECT id FROM sets WHERE url_title = $1 AND user_id = $2;'
    result = @connection.exec_params(sql, [url_title, user_id])
    result[0]['id'] unless result.ntuples.zero?
  end

  def cards(set_id)
    sql = 'SELECT term, definition FROM cards WHERE set_id = $1'
    result = @connection.exec_params(sql, [set_id])
    result.values
  end

  def display_title(set_id, user_id)
    sql = 'SELECT display_title FROM sets WHERE id = $1 AND user_id = $2;'
    result = @connection.exec_params(sql, [set_id, user_id])
    result[0]['display_title'] unless result.ntuples.zero?
  end

  def set_titles
    sql = 'SELECT display_title, url_title from sets;' 
    result = @connection.exec(sql)
    result.values
  end

  def set_titles_matching(query)
    escaped_query = PG::Connection.escape_string(query)
    sql = <<~SQL
      SELECT     sets.display_title, 
                 sets.url_title, 
                 users.name, 
                 Count(cards.id) AS num_terms 
      FROM       sets 
      INNER JOIN users 
      ON         sets.user_id = users.id 
      INNER JOIN cards 
      ON         sets.id = cards.set_id 
      WHERE      display_title ilike '%#{escaped_query}%'
      GROUP BY   sets.display_title, sets.url_title, users.name;
    SQL
    result = @connection.exec(sql)
    result.values unless result.nil?
  end

  def cards_matching(query)
    escaped_query = PG::Connection.escape_string(query)
    sql = <<~SQL
      SELECT     c.set_id,
                 c.term,
                 c.definition,
                 s.display_title,
                 s.url_title,
                 u.name
      FROM       cards as c
      INNER JOIN sets as s
      ON         c.set_id = s.id 
      INNER JOIN users as u
      ON         s.user_id = u.id
      WHERE      term ilike '%#{escaped_query}%'
      OR         definition ilike '%#{escaped_query}%';
    SQL
    result = @connection.exec(sql)
    return if result.nil?

    hash = {}
    result.values.each do |card|
      if hash[card[0]].nil?
        hash[card[0]] = {}
        hash[card[0]]['cards'] = [card[1..2]]
        hash[card[0]]['display_title'] = card[3] 
        hash[card[0]]['url_title'] = card[4] 
      else
        hash[card[0]]['cards'].push(card[1..2])
      end
    end

    [hash, result.values.size]
  end

  # UPDATE

  # DELETE
  def delete_card(card_id)
    sql = 'DELETE FROM cards WHERE id = $1'
    result = @connection.exec_params(sql, [card_id])
  end

  def disconnect
    @connection.close
  end
end
