select
    count(distinct file_name) as nb_files
from wizeobsidian.md_file_analysis;
------------------

select
count(file_name) as nb,
folder1,
CASE
    WHEN folder2 like '%.md%' THEN folder1
    ELSE folder2
end as folder2
from wizeobsidian.md_file_analysis
where folder1 <> '.trash'
group by folder1,folder2
order by nb desc;
--------------------
WITH data AS (
    SELECT
        folder1,
        folder2,
        folder3,
        folder4,
        folder5,
        file_name,
        is_more_than_20_char,
        update_date,
        CASE
            WHEN folder5 = file_name THEN folder4
            WHEN folder4 = file_name THEN folder3
            WHEN folder3 = file_name THEN folder2
            WHEN folder2 = file_name THEN folder1
            ELSE NULL
        END AS last_parent
    FROM wizeobsidian.md_file_analysis
)
SELECT
    last_parent,
    file_name,
    is_more_than_20_char,
    update_date
FROM data
WHERE last_parent IS NOT NULL;
---------------------------------

WITH last_parent_data AS (
    SELECT
        last_parent,
        file_name,
        is_more_than_20_char
    FROM wizeobsidian.last_parent
)
SELECT
    last_parent,
    COUNT(DISTINCT file_name) AS nb_note
FROM last_parent_data
WHERE 1=1
    AND is_more_than_20_char IS TRUE
GROUP BY last_parent
-----------------------------------------

select
    NLP.last_parent as subject,
    NLP.nb_note as total_note_of_subject,
    COALESCE(FNLP.nb_note,0) as total_field_notes_of_subject,
    (COALESCE(FNLP.nb_note,0)*1.00/NLP.nb_note*1.00)*100 as percent_subject_filed
from wizeobsidian.note_per_last_parent as NLP
left join wizeobsidian.filed_note_per_last_parent as FNLP
    ON FNLP.last_parent = NLP.last_parent

