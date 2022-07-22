/*
 * TRIGGERS ARCS
 * - ERE
 * - arc
 * - ARC
 * - EVENT
*/


SELECT * FROM public."Story_line_V2" 
where 1=1 
	and "Type" ='Event'
	AND "Summary" IS NOT NULL
ORDER BY last_refresh DESC;


DROP TABLE IF EXISTS arcs.arc_aeon;
CREATE TABLE arcs.arc_aeon
(
arc_id VARCHAR(20),
arc_name VARCHAR(200),
arc_evernote VARcHAR(5000),
arc_parent_name VARCHAR(200),
arc_faction VARCHAR(10),
arc_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_arc() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  arcs.arc_aeon
	where 1=1 
		and arc_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        arcs.arc_aeon(
	        arc_id,
			arc_name,
			arc_evernote ,
			arc_parent_name,
			arc_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");
RETURN new;
END;
$BODY$
language plpgsql;




CREATE  TRIGGER copy_arc
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Event' and new."Summary" like '%Arc%')
 EXECUTE PROCEDURE function_copy_arc();

