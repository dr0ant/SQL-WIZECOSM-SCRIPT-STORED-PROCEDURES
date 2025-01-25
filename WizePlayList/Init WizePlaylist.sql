Create schema wizeplaylist;

--drop table if exists wizeplaylist;
create table if not exists wizeplaylist.weekly_playlist
(
    id serial,
    entry_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    name varchar,
    album varchar,
    release_date date,
    popularity int,
    artist varchar,
    week_nb int,
    genre varchar
)

SELECT NOW() - INTERVAL '60 years';
