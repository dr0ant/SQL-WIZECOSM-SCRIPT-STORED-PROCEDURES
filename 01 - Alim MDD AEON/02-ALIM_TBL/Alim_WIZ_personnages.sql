create or replace function wizecosm.alim_wiz_personnages() returns character varying
    language plpgsql
as
$$
begin
    DELETE
    FROM wizecosm.wiz_personnages
    WHERE 1 = 1;

    INSERT INTO wizecosm.wiz_personnages (
                                         "character_type",
                                         "character_label",
                                         "character_identifier",
                                         "character_parent",
                                         "character_links",
                                         "character_relates_to",
                                         "character_character_type",
                                         "character_gender",
                                         "character_race",
                                         "character_faction",
                                         "character_goals",
                                         "character_nickname",
                                          "character_tags",
                                         added_date)
    SELECT src."Type",
           src."Label",
           src."Identifier",
           src."Parent",
           src."Links",
           src."Relates_to",
           src."Character_Type",
           src."Gender",
           src."Race",
           src."Faction",
           src."Goals",
           src."Nickname",
           src."Tags",
           NOW()
    FROM wizecosm."IMP_aeon" src
    WHERE 1 = 1
      AND src."Type" ='Character'
    ;
    RETURN 'OK';
END
$$;



