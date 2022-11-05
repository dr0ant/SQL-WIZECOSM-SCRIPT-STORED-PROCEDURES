
DROP table if exists  aoavfbel.wizecosm.wiz_personnages;

create table wizecosm.wiz_personnages
(
    character_type           varchar(200),
    character_label          varchar(200),
    character_identifier     varchar(200),
    character_parent         varchar(200),
    character_links          varchar(500),
    character_relates_to     varchar(500),
    character_character_type varchar(200),
    character_gender         varchar(200),
    character_race           varchar(200),
    character_faction        varchar(200),
    character_goals          varchar(500),
    character_nickname       varchar(200),
    character_tags           varchar(300),
    added_date               timestamp
);

alter table wizecosm.wiz_personnages
    owner to aoavfbel;
