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


DROP TABLE IF EXISTS arcs.Ere_aeon;
CREATE TABLE arcs.Ere_aeon
(
ere_id VARCHAR(20),
ere_name VARCHAR(500),
ere_evernote VARcHAR(5000),
ere_parent_name VARCHAR(500),
ere_faction VARCHAR(10),
ere_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_ere() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  arcs.ere_aeon
	where 1=1 
		and ere_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        arcs.ere_aeon(
	        ere_id,
			ere_name,
			ere_evernote ,
			ere_parent_name,
			ere_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");

RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER copy_ere
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Event'and new."Summary" like '%Ere%')
 EXECUTE PROCEDURE function_copy_ere();

