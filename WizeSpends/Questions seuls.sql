/*
 PARTIE 0 Connexion Database :
 */

-- SQL type : PostgresSQL
--
-- Host : ella.db.elephantsql.com
-- user : aoavfbel
-- pass : UZiRSP_r1rtQZiLN3plQwbZv4LiYfgXR
-- database : aoavfbel
-- (schema : wizespends) --> pas necessaire à la connexion




/*
  PARTIE 1 QUERY DATABASE
 */

-- Combien y a t'il de lignes dans la table IMP_operations


-- Combien y a t'il de "Libellé" différents dans la  table IMP_operations


-- En 2021, quel est le volume de dépenses totales ?


-- Quelle est la date la plus ancienne de la table ?


-- Remonter uniquement les informations de la ligne la plus ancienne par date ( tous les champs)


-- Quel est le volume de revenu & dépenses par an trié par ordre décroissant ?


-- trier les lignes de la questin précédent par  excédent (revenu > dépense le plus gros)




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


-- intégrer les données de wizespends.IMP_operations dans wizespends.spends_operations
