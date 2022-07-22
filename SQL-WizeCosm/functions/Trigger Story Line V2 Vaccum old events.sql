/*
 * TRIGGER MAIN TABLE PUBLIC ==> VACCUM OLD EVENTS
*/


CREATE OR REPLACE FUNCTION vaccum_story_old() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  public."Story_line_V2"
	where 1=1 
		and "Story_line_V2".created_at  < now() ;
RETURN new;
END;
$BODY$
language plpgsql;



CREATE  TRIGGER DELETE_OLD_STORY
 BEFORE INSERT
       ON public."Story_line_V2"
 FOR EACH row
 EXECUTE PROCEDURE vaccum_story_old();

alter table public."Story_line_V2" 
add column created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

alter table public."Story_line_V2" 
add column  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW() ;