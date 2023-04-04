/*
 * TRIGGERS ARCS
 * - ERE
 * - PERIODE
 * - ARC
 * - EVENT
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Event'
	AND "Summary" IS NOT NULL
ORDER BY last_refresh DESC;


DROP TABLE IF EXISTS arcs.periode_aeon;
CREATE TABLE arcs.periode_aeon
(
Periode_id VARCHAR(20),
Periode_name VARCHAR(200),
Periode_evernote VARcHAR(5000),
Periode_parent_name VARCHAR(200),
Periode_faction VARCHAR(10),
Periode_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_periode() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  arcs.periode_aeon
	where 1=1 
		and periode_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        arcs.periode_aeon(
	        periode_id,
			periode_name,
			periode_evernote ,
			periode_parent_name,
			periode_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");
RETURN new;
END;
$BODY$
language plpgsql;




CREATE  TRIGGER copy_periode
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Event' and new."Summary" like '%Période%')
 EXECUTE PROCEDURE function_copy_periode();

