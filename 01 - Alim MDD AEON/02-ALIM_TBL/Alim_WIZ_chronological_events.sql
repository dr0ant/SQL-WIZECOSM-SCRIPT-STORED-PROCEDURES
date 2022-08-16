create function Alim_WIZ_chronological_events() returns varchar
    language plpgsql
as
$$
begin
    DELETE
    FROM wiz_chronological_events
    WHERE 1 = 1;

    INSERT INTO wiz_chronological_events(Type, Label, OBJ_ID, chronological_position, Parent_OBJ_ID, start_date,
                                         duration,
                                         end_date, Blocked_BY, Blocks, Evernote_LINk, location, ADDED_DATE)
    SELECT src."Type",
           src."Label",
           src."Identifier",
           src."Chronological_Position",
           src."Parent",
           to_date(src."Start_Date", 'YYYY-MM-DD'),
           src."Duration",
           to_date(src."End_Date", 'YYYY-MM-DD'),
           src."Blocked_By",
           src."Blocks",
           src."Links",
           src."Location",
           NOW()
    FROM "IMP_aeon_data" src
    WHERE 1 = 1
      AND src."Type" IN ('Periode', 'Arc', 'Ere', 'Backstory', 'Flashback', 'Event');
    RETURN 'OK';
END;
$$;





