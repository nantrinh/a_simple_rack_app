drop table cards;
drop table sets;
drop table users;

create table users (
  id serial primary key,
  name varchar(50) unique not null
);

create table sets (
  id serial primary key,
  display_title varchar(255) not null,
  url_title varchar(255) not null,
  user_id integer not null references users(id),
  unique(url_title, user_id)
);

create table cards (
  id serial primary key,
  set_id integer not null references sets(id) on delete cascade,
  term text,
  definition text
);

insert into users (name) values ('public');
