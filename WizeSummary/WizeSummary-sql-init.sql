
drop table if exists wizecosm.notes_to_summarize;
create table wizecosm.notes_to_summarize
(
    note_id      serial
        primary key,
    index        integer,
    note_path    varchar,
    created_date timestamp default now(),
    updated_date timestamp default now()
);


INSERT INTO wizecosm.notes_to_summarize ("index", note_path) VALUES
(1, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/01 - Phase 1/Phase 1 - les Séquelles de la guerre.md'),
(2, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/02 - Phase 2/Phase 2 - Mia.md'),
(3, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/03 - Phase 3/Phase 3 - La pluie d''étoiles.md'),
(4, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/04 - Phase 4/Phase 4 - L''équipage.md'),
(5, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 01/Partie 1 - La traversée.md'),
(6, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 02/Partie 2 - la découverte des îles.md'),
(7, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 03/Partie 3 - Rencontre équipages Yamés ¦ Gamé.md');








drop table if exists wizecosm.wize_summaries;
create table wizecosm.wize_summaries
(
    summary_id   serial
        primary key,
    index        integer,
    summary      varchar,
    bullet_summary varchar,
    note_id      integer
        references wizecosm.notes_to_summarize
            on delete cascade,
    created_date timestamp default now(),
    updated_date timestamp default now(),
    constraint unique_note_index
        unique (summary_id, index),
    constraint unique_note_index_2
        unique (note_id, index)
);


