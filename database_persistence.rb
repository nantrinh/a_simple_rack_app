require 'pry'
require 'pg'

class DatabasePersistence
  def initialize
    @connection = PG.connect(dbname: 'codecards')
  end

  # CREATE (INSERT)
  def create_set(title, user_id)
    sql = 'INSERT INTO sets (title, user_id) VALUES ($1, $2);'
    @connection.exec_params(sql, [title, user_id])
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

  def set_id(title, user_id)
    sql = 'SELECT id FROM sets WHERE title = $1 AND user_id = $2;'
    result = @connection.exec_params(sql, [title, user_id])
    result[0]['id'] unless result.ntuples.zero?
  end
  
  def cards(set_id)
    sql = 'SELECT term, definition FROM cards WHERE set_id = $1'
    result = @connection.exec_params(sql, [set_id])
    result.values
  end

  # UPDATE

  # DELETE
  def delete_card(card_id)
    sql = 'DELETE FROM cards WHERE id = $1'
    result = @connection.exec_params(sql, [card_id])
  end

end
