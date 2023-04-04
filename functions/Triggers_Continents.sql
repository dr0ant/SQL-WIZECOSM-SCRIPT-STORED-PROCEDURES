/*
 * TRIGGERS GEOGRAPHY
 * - CONTINENTS
 * - PAYS
 * - CAPITALES
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Place'
order by created_at desc;


drop table geographie.continent_aeon;
CREATE TABLE geographie.continent_aeon
(
Continent_id VARCHAR(20),
Continent_name VARCHAR(50),
Continent_evernote VARcHAR(5000),
Continent_parent_name VARCHAR(50),
Continent_faction VARCHAR(10),
Continent_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_continents() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  geographie.continent_aeon
	where 1=1 
		and "continent_added_date" < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        geographie.continent_aeon(
	        continent_id,
			continent_name,
			continent_evernote ,
			continent_parent_name,
			continent_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");

RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER copy_continents
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Place'and new."Label" like '%Continent%')
 EXECUTE PROCEDURE function_copy_continents();

