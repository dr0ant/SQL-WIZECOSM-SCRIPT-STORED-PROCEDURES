WITH ERE
AS
    (
        SELECT * FROM "IMP_aeon_data" imp
                 WHERE 1=1
                    AND imp."Type" ='Ere'
    ),
PERIODE
AS
    (
        SELECT * FROM "IMP_aeon_data" imp
                 WHERE 1=1
                    AND imp."Type" ='Periode'
    ),
ARC
AS
    (
        SELECT * FROM "IMP_aeon_data" imp
                 WHERE 1=1
                    AND imp."Type" ='Arc'
    ),
EVENT
AS
    (
      SELECT * FROM "IMP_aeon_data" imp
                 WHERE 1=1
                    AND imp."Type" ='Event'
    )
SELECT
ERE."Identifier" AS E_ID,
PER."Identifier" AS P_ID,
ARC."Identifier" AS A_ID,
EV."Identifier" AS EE_ID,
to_date(EV."Start_Date",'YYYY-MM-DD') AS D_START_DATE,
date_part('year',to_date(EV."Start_Date",'YYYY-MM-DD')) AS S_YEAR,
date_part('year',to_date(EV."Start_Date",'YYYY-MM-DD')) /1000 AS S_YEAR,
to_date(EV."End_Date",'YYYY-MM-DD') AS D_END_DATE,
date_part('year',to_date(EV."End_Date",'YYYY-MM-DD')) AS E_YEAR
FROM EVENT EV
LEFT JOIN ARC
    ON EV."Parent" = ARC."Identifier"
LEFT JOIN PERIODE  PER
    ON ARC."Parent" = PER."Identifier"
LEFT JOIN ERE
    ON PER."Parent" = ERE."Identifier"