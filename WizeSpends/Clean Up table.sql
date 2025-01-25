
/*
  PARTIE 1 QUERY DATABASE
 */



-- Combien y a t'il de lignes dans la table IMP_operations
SELECT COUNT(*) FROM wizespends."IMP_operations";

-- Combien y a t'il de "Libellé" différents dans la lka table IMP_operations
SELECT COUNT(DISTINCT "Libellé") FROM wizespends."IMP_operations";


-- En 2021, quel est le volume de dépenses totales ?

SELECT
    DATE_PART('YEAR',TO_DATE(spends."Date", 'DD/MM/YYYY')) AS YEARS ,
    SUM( CASE
            WHEN spends."Montant" LIKE '%-%' THEN REPLACE(spends."Montant",',','.')::numeric
            ELSE 0
        END) AS spends_YEAR
FROM wizespends."IMP_operations" as spends
WHERE 1=1
AND     DATE_PART('YEAR',TO_DATE(spends."Date", 'DD/MM/YYYY'))  = '2021'
GROUP BY YEARS;


-- Quelle est la date la plus ancienne de la table ?

SELECT
    MIN(TO_DATE(spends."Date", 'DD/MM/YYYY'))
FROM  wizespends."IMP_operations" as spends
;;;


-- Remonter uniquement les informations de la ligne la plus ancienne par date ( tous les champs)

WITH DATAS AS
         (SELECT spends.*,
                 row_number() over (PARTITION BY 1 ORDER BY TO_DATE(spends."Date", 'DD/MM/YYYY') ASC ) AS RANKS
          FROM wizespends."IMP_operations" as spends)
SELECT
    *
FROM DATAS
WHERE 1=1
    AND RANKS =1
;

-- Quel est le volume de revenu & dépenses par an trié par ordre décroissant ?

SELECT
    DATE_PART('YEAR',TO_DATE(spends."Date", 'DD/MM/YYYY')) AS YEARS ,
       SUM( CASE
            WHEN spends."Montant" LIKE '%-%' THEN REPLACE(spends."Montant",',','.')::numeric
            ELSE 0
        END) AS spends_YEAR,
        SUM( CASE
            WHEN spends."Montant" NOT LIKE '%-%' THEN REPLACE(spends."Montant",',','.')::numeric
            ELSE 0
        END) AS revenu_YEAR
FROM wizespends."IMP_operations" as spends
WHERE 1=1
GROUP BY YEARS
ORDER BY YEARS DESC ;

-- trier les lignes de la questin précédent par  excédent (revenu > dépense le plus gros)
WITH DATAS
    AS
         (SELECT DATE_PART('YEAR', TO_DATE(spends."Date", 'DD/MM/YYYY')) AS YEARS,
                 SUM(CASE
                         WHEN spends."Montant" LIKE '%-%' THEN REPLACE(spends."Montant", ',', '.')::numeric
                         ELSE 0
                     END)                                                AS spends_YEAR,
                 SUM(CASE
                         WHEN spends."Montant" NOT LIKE '%-%' THEN REPLACE(spends."Montant", ',', '.')::numeric
                         ELSE 0
                     END)                                                AS revenu_YEAR
          FROM wizespends."IMP_operations" as spends
          WHERE 1 = 1
          GROUP BY YEARS
          ORDER BY YEARS DESC)
SELECT
* ,
(spends_YEAR + revenu_YEAR) AS excedent
FROM DATAS
ORDER BY excedent DESC ;



/*
  PARTIE 2 DATA Ingeneering
 */
-- Créer une table de nom :spends_operations dans le schema wizespends
-- avec ces champs
-- date -->  date
-- libelle --> varchar 500
-- catégorie --> varchar 500
-- montant --> numeric
-- notes --> varchar 500
-- n_cheque --> varchar 100
-- labels --> varchar 100
-- num_compte --> varchar 500
-- num_connexion --> varchar 200
-- _import_date --> date de l'insertion de la donnée en base

DROP TABLE IF EXISTS wizespends.spends_operations;
CREATE TABLE wizespends.spends_operations
(
    date          date,
    libelle       varchar(500),
    catégorie     varchar(500),
    montant       numeric,
    notes         varchar(500),
    n_cheque      varchar(100),
    labels        varchar(100),
    num_compte    varchar(500),
    num_connexion varchar(500),
    _import_date  date not null default current_date
)
;

-- intégrer les données de wizespends.IMP_operations dans wizespends.spends_operations

INSERT INTO wizespends.spends_operations
(date,
 libelle,
 catégorie,
 montant,
 notes,
 n_cheque,
 labels,
 num_compte,
 num_connexion)
SELECT
    TO_DATE(spends."Date", 'DD/MM/YYYY'),
    "Libellé",
    "Catégorie",
    REPLACE("Montant",',','.')::numeric,
    "Notes",
    "N° de chèque",
    "Labels",
    "Nom du compte",
    "Nom de la connexion"
FROM wizespends."IMP_operations" as spends









