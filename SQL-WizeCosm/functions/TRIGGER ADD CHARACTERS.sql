/*
 * TRIGGER POUR INSERER DANS LES TABLES DE 
 * - personnage
*/

 
alter table public."Story_line_V2" add column last_refresh  timestamptz NOT NULL DEFAULT now();

select * from public."Story_line_V2" as SL
where 1=1
	and SL."Type" = 'Character'
order by SL.created_at  desc 
;

drop table personnages.personnages_aeon;
create table personnages.personnages_aeon
(
personnage_id VARCHAR(20),
personnage_name varchar(50),
personnage_evernote varchar(3000),
personnage_faction VARCHAR(20),
personnage_gender VARCHAR(20),
personnage_type VARCHAR(300),
personnage_friends VARCHAR(5000),
personnage_organisations VARCHAR(5000),
personnage_nickname VARCHAR(500),
personnage_parent VARCHAR(500),
personnage_race VARCHAR(500),
personnage_notes VARCHAR(1000),
personnage_added_date  timestamptz NOT NULL DEFAULT now()
)
;



DROP TABLE public."Story_line_V2";


-- Step 1: Create the function that inserts


CREATE OR REPLACE FUNCTION function_copy() RETURNS TRIGGER AS
$BODY$
begin	
	-- DELETE OLD VALUES
delete from  personnages.personnages_aeon 
	where 1=1 
		and "personnage_added_date" < now() ;
	-- INSERT NEW ONES
INSERT INTO
	        personnages.personnages_aeon(personnage_id,
	        personnage_name,
	        personnage_evernote,
	        personnage_faction,
	        personnage_gender,
	        personnage_type,
	        personnage_friends,
	        personnage_organisations,
	        personnage_nickname,
	        personnage_parent,
	        personnage_race,
	        personnage_notes)
	     VALUES(new."Display ID",
                new."Label",
                new."Links",
                new."Tags",
                new."Gender",
                new."Character Type",
                new."Friend",
                new."Relates to",
                new."Nickname",
                new."Parent_1",
               	new."Traits",
               	new."Notes");

RETURN new;
END;
$BODY$
language plpgsql;



-- Step 2: create the trigger



CREATE  TRIGGER copy_personnage
 AFTER INSERT
       ON public."Story_line_V2"
 FOR EACH row
 WHEN (NEW."Type" ='Character')
 EXECUTE PROCEDURE function_copy();



