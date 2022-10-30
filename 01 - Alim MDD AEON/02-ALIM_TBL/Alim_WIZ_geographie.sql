create or replace function wizecosm.alim_wiz_geographie() returns character varying
    language plpgsql
as
$$
begin
    DELETE
    FROM wizecosm.wiz_geographie
    WHERE 1 = 1;

    INSERT INTO wizecosm.wiz_geographie (
                                            objet_geographique_type,
                                            objet_geographique_id,
                                            objet_geographique_name,
                                            objet_geographique_evernote,
                                            objet_geographique_parent_name,
                                            objet_geographique_faction,
                                            objet_geographique_added_date
                                         )
    SELECT TRIM("left"("Label",position('-' in "Label")-1)),
           src."Identifier",
           TRIM(right(src."Label",length("Label")-position('-' in "Label"))),
           src."Links",
           TRIM(right(src."Parent",length("Parent")-position('-' in "Parent"))),
           src."Tags",
           NOW()
    FROM wizecosm."IMP_aeon" src
    WHERE 1 = 1
      AND src."Type" ='Place'
    ;
    RETURN 'OK';
END
$$;



