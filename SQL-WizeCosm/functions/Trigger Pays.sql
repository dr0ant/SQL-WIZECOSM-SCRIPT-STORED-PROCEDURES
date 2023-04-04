/*
 * TRIGGERS GEOGRAPHY
 * - PAYS
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Place'
order by created_at desc;


drop table if exists geographie.Pays_aeon;
CREATE TABLE geographie.Pays_aeon
(
Pays_id VARCHAR(20),
Pays_name VARCHAR(50),
Pays_evernote VARcHAR(5000),
Pays_parent_name VARCHAR(50),
Pays_faction VARCHAR(10),
Pays_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_Pays() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  geographie.Pays_aeon
	where 1=1 
		and Pays_aeon.Pays_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        geographie.Pays_aeon(
	        Pays_id,
			Pays_name,
			Pays_evernote ,
			Pays_parent_name,
			Pays_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");

RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER copy_Pays
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Place'and new."Label" like '%Pays%')
 EXECUTE PROCEDURE function_copy_Pays();

