/*
 * TRIGGERS GEOGRAPHY
* -Capitales
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Place'
order by created_at desc;


drop table if exists geographie.Capitale_aeon;
CREATE TABLE geographie.Capitale_aeon
(
Capitale_id VARCHAR(20),
Capitale_name VARCHAR(50),
Capitale_evernote VARcHAR(5000),
Capitale_parent_name VARCHAR(50),
Capitale_faction VARCHAR(10),
Capitale_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_Capitale() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  geographie.Capitale_aeon
	where 1=1 
		and Capitale_aeon.Capitale_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        geographie.Capitale_aeon(
	        Capitale_id,
			Capitale_name,
			Capitale_evernote ,
			Capitale_parent_name,
			Capitale_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");

RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER copy_Capitale
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Place'and new."Label" like '%Capitale%')
 EXECUTE PROCEDURE function_copy_Capitale();

