def add_set(title)
  sql = 'INSERT INTO sets (title) VALUES ($1);'
  @connection.exec_params(sql, [title])
end

def add_user(name)
  sql = 'INSERT INTO users (name) VALUES ($1);'
  @connection.exec_params(sql, [name])
end

def add_card(set_id, term, definition)
  sql = 'INSERT INTO cards (set_id, term, definition) VALUES ($1, $2, $3);'
  @connection.exec_params(sql, [set_id, term, definition])
end

def add_set_user(set_id, user_id)
  sql = 'INSERT INTO sets_users (set_id, user_id) VALUES ($1, $2);'
  @connection.exec_params(sql, [set_id, user_id])
end

def delete_card(card_id)
  sql = 'DELETE FROM cards WHERE id = $1'
  result = @connection.exec_params(sql, [card_id])
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
