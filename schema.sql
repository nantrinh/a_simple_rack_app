create table sets (
  id serial primary key,
  title varchar(255) not null
);

create table users (
  id serial primary key,
  name varchar(50) not null
);

create table cards (
  id serial primary key,
  set_id integer not null references sets(id),
  term text,
  definition text
);

create table sets_users (
  id serial primary key,
  user_id integer not null references users(id),
  sets_id integer not null references sets(id)
);
