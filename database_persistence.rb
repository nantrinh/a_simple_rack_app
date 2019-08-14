require 'pry'
require 'pg'

class DatabasePersistence
  def initialize
    @connection = PG.connect(dbname: 'codecards')
  end

  def add_set(title, user_id)
    sql = 'INSERT INTO sets (title, user_id) VALUES ($1, $2);'
    @connection.exec_params(sql, [title, user_id])
  end
  
  def add_user(name)
    sql = 'INSERT INTO users (name) VALUES ($1);'
    @connection.exec_params(sql, [name])
  end

  def add_card(set_id, term, definition)
    sql = 'INSERT INTO cards (set_id, term, definition) VALUES ($1, $2, $3);'
    @connection.exec_params(sql, [set_id, term, definition])
  end
  
  def delete_card(card_id)
    sql = 'DELETE FROM cards WHERE id = $1'
    result = @connection.exec_params(sql, [card_id])
  end
 
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
  
  def select_cards(set_id)
    sql = 'SELECT * FROM cards WHERE set_id = $1'
    result = @connection.exec_params(sql, [set_id])
  end
  
  # not sure if this is needed
  def setup_schema_sets
    result = @connection.exec <<~SQL
      SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema = 'public' AND table_name = 'sets';
    SQL
  
    if result[0]["count"] == "0"
      @connection.exec <<~SQL
      create table sets (
        id serial primary key,
        title varchar(255) not null
      );
      SQL
    end
  end
end
