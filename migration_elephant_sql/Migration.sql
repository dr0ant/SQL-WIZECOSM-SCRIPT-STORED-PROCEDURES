CREATE SERVER db_aoavfbel
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'ella.db.elephantsql.com', port '5432', dbname 'aoavfbel');

CREATE USER MAPPING FOR dr0ant
    SERVER remote_server
    OPTIONS (user 'aoavfbel', password 'UZiRSP_r1rtQZiLN3plQwbZv4LiYfgXR');


select * from db_aoavfbel.public.dates_months;

