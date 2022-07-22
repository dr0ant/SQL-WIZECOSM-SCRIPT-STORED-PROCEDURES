/*
 * TRIGGERS GEOGRAPHY
 * - LieuS
 * - PAYS
 * - CAPITALES
 * - LIEU
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Place'
order by created_at desc;


DROP TABLE IF EXISTS geographie.lieu_aeon;
CREATE TABLE geographie.lieu_aeon
(
lieu_id VARCHAR(20),
lieu_name VARCHAR(50),
lieu_evernote VARcHAR(5000),
Lieu_parent_name VARCHAR(50),
Lieu_faction VARCHAR(10),
Lieu_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_Lieu() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  geographie.Lieu_aeon
	where 1=1 
		and Lieu_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        geographie.Lieu_aeon(
	        Lieu_id,
			Lieu_name,
			Lieu_evernote ,
			Lieu_parent_name,
			Lieu_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");

RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER copy_Lieu
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Place'and new."Label" like '%Lieu%')
 EXECUTE PROCEDURE function_copy_Lieu();

