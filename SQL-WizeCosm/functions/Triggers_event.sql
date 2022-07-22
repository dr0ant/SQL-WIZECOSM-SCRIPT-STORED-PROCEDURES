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


DROP TABLE IF EXISTS arcs.event_aeon;
CREATE TABLE arcs.event_aeon
(
event_id VARCHAR(20),
event_name VARCHAR(200),
event_evernote VARcHAR(5000),
event_parent_name VARCHAR(200),
event_faction VARCHAR(10),
event_added_date timestamptz NOT NULL DEFAULT now()
)
;

/*
 * FUNCTION TRIGGER 
 */

CREATE OR REPLACE FUNCTION function_copy_event() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  arcs.event_aeon
	where 1=1 
		and event_added_date < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        arcs.event_aeon(
	        event_id,
			event_name,
			event_evernote ,
			event_parent_name,
			event_faction)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Parent",
                new."Tags");
RETURN new;
END;
$BODY$
language plpgsql;




CREATE  TRIGGER copy_event
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Event' and new."Summary" like '%Event%')
 EXECUTE PROCEDURE function_copy_event();

