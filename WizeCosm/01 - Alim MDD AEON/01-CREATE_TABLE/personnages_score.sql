CREATE TABLE wizecosm.personnage_score
(
    character_identifier VARCHAR(2000),
    character_label VARCHAR(2000),
    character_type VARCHAR(2000),
    character_score_lowest INT,
    character_score_highest INT
);




INSERT into wizecosm.personnage_score(character_identifier, character_label, character_type)
SELECT DISTINCT
    per.character_identifier,
    per.character_label,
    per.character_parent
FROM wizecosm.wiz_personnages per;



UPDATE wizecosm.personnage_score
SET moment_score_event ='08 - Arc 2 - Tournois des Cosmers'
WHERE 1=1
    AND character_label in ('Irisio','Aïbnus')




UPDATE wizecosm.personnage_score
SET moment_score_event ='05 - Arc 1 - Le voyage de Hank'
WHERE 1=1
    AND character_type in ('Equipage Gamé','Equipage Yamé')


;;;;;;;;;;;;;;;;;;;;;;;;;

CREATE VIEW wizecosm.character_ranking_arc
AS
    (
    SELECT
        *
    , row_number() over (partition by moment_score_event order by character_score desc ) AS RANK_ARC
    FROM wizecosm.personnage_score
    ORDER BY RANK_ARC desc
    );



CREATE VIEW wizecosm.character_ranking_all_time
AS
    (
    WITH DATAS
        AS
             (SELECT *,
                     row_number()
                     over (partition by character_identifier order by convert_to_int(LEFT(moment_score_event, 2)) desc) AS LAST_SCORE
              FROM wizecosm.personnage_score
              WHERE 1 = 1
                AND moment_score_event <> 'INIT')
    SELECT
    *,
    row_number() over (order by character_score desc ) AS character_rank
    FROM DATAS
    WHERE 1=1
        AND LAST_SCORE =1
    );







