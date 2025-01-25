create or replace view wizecosm.V_continents
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
    FROM wizecosm.wiz_geographie as geo1
    LEFT JOIN wizecosm.wiz_geographie geo2
        ON geo1.objet_geographique_parent_name = geo2.objet_geographique_name
    WHERE 1=1
        AND geo1.objet_geographique_type = 'Continent'
    )
;