create table wizecosm.wiz_geographie
(
    objet_geographique_type        varchar(20),
    objet_geographique_id          varchar(20),
    objet_geographique_name        varchar(50),
    objet_geographique_evernote    varchar(5000),
    objet_geographique_parent_name varchar(50),
    objet_geographique_faction     varchar(10),
    objet_geographique_added_date  timestamp with time zone default now() not null
);

