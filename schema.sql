drop table users;
drop table sets;
drop table cards;

create table users (
  id serial primary key,
  name varchar(50) unique not null
);

create table sets (
  id serial primary key,
  title varchar(255) not null,
  user_id integer not null references users(id),
  unique(title, user_id)
);

create table cards (
  id serial primary key,
  set_id integer not null references sets(id),
  term text,
  definition text
);

insert into users (name) values ('public');
