---------------------------------------------------
WITH DATAS
    AS
         (SELECT "Profile Name"                                 AS Profile,
                 "Start Time"::TIMESTAMP                        as Start_time,
                 EXTRACT(hour FROM "Duration"::time) + EXTRACT(minute FROM "Duration"::time) / 60.0 +
                 EXTRACT(second FROM "Duration"::time) / 3600.0 AS Duration_in_hours,
                 "Attributes",
                 "Title",
                 "Device Type",
                 "Bookmark",
                 "Country"
          FROM "WizeAnalytics".netflix_viewing_activities
          WHERE 1 = 1
            AND "Profile Name" = 'Larcher fam')
SELECT
    Profile,
    Min(Start_time) as first_watch_time,
    Max(Start_time) as last_watched_time,
    SUM(Duration_in_hours) as Nb_hours,
    SUM(Duration_in_hours)*1.00/24 AS Nb_days,
    (SUM(Duration_in_hours)*1.00/24 )/365 AS NB_YEARS
FROM DATAS
GROUP BY Profile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


CREATE VIEW "WizeAnalytics".v_reworked_netflix_viewing_activites
AS
    (
    SELECT "Profile Name"                                 AS Profile,
                 "Start Time"::TIMESTAMP                        as Start_time,
                 EXTRACT(hour FROM "Duration"::time) + EXTRACT(minute FROM "Duration"::time) / 60.0 +
                 EXTRACT(second FROM "Duration"::time) / 3600.0 AS Duration_in_hours,
                 "Attributes",
                 "Title",
                 "Device Type",
                 "Bookmark",
                 "Country"
          FROM "WizeAnalytics".netflix_viewing_activities
          WHERE 1 = 1
    )
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CREATE VIEW "WizeAnalytics".netflix_activilites_content
AS
(
SELECT CASE
           WHEN char_length(SPLIT_PART("Title", ':', 2)) = 0 THEN 'Film'
           ELSE 'Serie'
           END                     as type_content,
       SPLIT_PART("Title", ':', 1) AS titre,
       SPLIT_PART("Title", ':', 2) AS saison,
       SPLIT_PART("Title", ':', 3) AS episode,
       *
FROM "WizeAnalytics".v_reworked_netflix_viewing_activites
WHERE 1 = 1
      --AND profile = 'Larcher fam'
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SELECT
   titre,
    SUM(duration_in_hours) AS time_spend_on_content
FROM "WizeAnalytics".v_netflix_activilites_content
WHERE 1=1
    AND profile ='Larcher fam'
GROUP BY titre
ORDER BY time_spend_on_content DESC ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WITH DATAS
    AS
         (SELECT DATE(con.start_time) AS DATE,
                 SUM(con.duration_in_hours) AS daily_watchtime
          FROM "WizeAnalytics".v_netflix_activilites_content con
          WHERE 1 = 1
            AND con.profile = 'Larcher fam'
          group by DATE)
SELECT
    AVG(daily_watchtime)
FROM DATAS


