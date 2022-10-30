create or replace view "WizeCosm".V_pays
AS
    (
    SELECT
    geo1.objet_geographique_type,
    geo1.objet_geographique_id,
    geo1.objet_geographique_name,
    geo1.objet_geographique_evernote,
    geo1.objet_geographique_parent_name,
    geo1.objet_geographique_faction,
    geo1.objet_geographique_added_date,
    geo2.objet_geographique_id as parent_id
    FROM "WizeCosm".wiz_geographie as geo1
    LEFT JOIN "WizeCosm".wiz_geographie geo2
        ON geo1.objet_geographique_parent_name = geo2.objet_geographique_name
    WHERE 1=1
        AND geo1.objet_geographique_type = 'Pays'
    )
;