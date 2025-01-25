drop table if exists wizecosm.wize_summaries;
drop table if exists wizecosm.notes_to_summarize;
-- Create the first table if it doesn't exist
CREATE TABLE IF NOT EXISTS wizecosm.notes_to_summarize (
    note_id SERIAL PRIMARY KEY,
    "index" INT,
    note_path VARCHAR,
    created_date TIMESTAMP DEFAULT NOW(),
    updated_date TIMESTAMP DEFAULT NOW()
);


-- Create the second table if it doesn't exist
drop table if exists wizecosm.wize_summaries;
truncate table  wizecosm.notes_to_summarize;

INSERT INTO wizecosm.notes_to_summarize ("index", note_path) VALUES
(1, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/01 - Phase 1/Phase 1 - les Séquelles de la guerre.md'),
(2, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/02 - Phase 2/Phase 2 - Mia.md'),
(3, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/03 - Phase 3/Phase 3 - La pluie d''étoiles.md'),
(4, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/04 - Phase 4/Phase 4 - L''équipage.md'),
(5, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 01/Partie 1 - La traversée.md'),
(6, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 02/Partie 2 - la découverte des îles.md'),
(7, '/Users/antoinelarcher/Library/Mobile Documents/iCloud~md~obsidian/Documents/WizeCosm/04 - Arcs/05 - Arc 1/PART 03/Partie 3 - Rencontre équipages Yamés ¦ Gamé.md');



CREATE TABLE IF NOT EXISTS wizecosm.wize_summaries (
    summary_id SERIAL PRIMARY KEY,
    "index" INT,
    summary VARCHAR,
    note_id INT,
    created_date TIMESTAMP DEFAULT NOW(),
    updated_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (note_id) REFERENCES wizecosm.notes_to_summarize(note_id) ON DELETE CASCADE
);
ALTER TABLE wizecosm.wize_summaries
ADD CONSTRAINT unique_note_index_2 UNIQUE (note_id, "index");






select
note_id,
index,
note_path,
created_date,
updated_date
from wizecosm.notes_to_summarize;



/*
-- Insert or update a summary in wize_summaries
INSERT INTO wizecosm.wize_summaries (note_id, "index", summary, created_date, updated_date)
VALUES (1, 1, 'test summary content', NOW(), NOW())
ON CONFLICT (note_id , "index")
DO UPDATE SET
    summary = EXCLUDED.summary,
    updated_date = NOW();

*/
select * from wizecosm.wize_summaries order by "index" ;





