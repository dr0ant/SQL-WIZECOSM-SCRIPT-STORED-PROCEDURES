/*
 *  Niveau 1 time
 */
drop view arcs.Time_Area;
create or replace view arcs.Time_Area
as
(
with datas 
as
(
select 
STO."EventID"  as Time_area_id,
STO."Title" as Time_area_name,
case 
	when left(STO."EventID",1) = '1' then   Concat((STO."Start Date"),' BC')::date
	else STO."Start Date" 
end as Time_area_start_date2,

case 
	when left(STO."EventID",1) = '1' then   Concat(STO."End Date",' BC')::date
	else STO."End Date" 
end  as Time_area_end_date2,	
STO."Duration" as Time_area_duration_string,
row_number() over (partition by STO."EventID" order by STO.updated_at desc) as is_last
from public."Story_line" as STO
where 1=1
	and Sto."EventID" not like '%.%'
order by sto."EventID" asc
)
select 
*
,
case when date_part('year',Time_area_start_date2) < 0 then 'Avant An 0'
else 'Après An 0'
end as An_0
from datas as d
where 1=1
	and d.is_last= 1
)
;;;;;;;;;;;;;;;;;;;;;;;

/*
 * Niveau 2 time
 */
drop view arcs.Time_sub_area;
create or replace view arcs.Time_sub_area
as
(
with datas 
as
(
select 
STO."EventID"  as Time_area_id,
STO."Title" as Time_area_name,
case 
	when left(STO."EventID",1) = '1' then   Concat((STO."Start Date"),' BC')::date
	else STO."Start Date" 
end as Time_sub_area_start_date2,
case 
	when left(STO."EventID",1) = '1' then   Concat(STO."End Date",' BC')::date
	else STO."End Date" 
end  as Time_sub_area_end_date2,	
STO."Duration" as Time_area_sub_duration_string,
row_number() over (partition by STO."EventID" order by STO.updated_at desc) as is_last
from public."Story_line" as STO
where 1=1
	and Sto."EventID"  like '%.%'
	and (CHAR_LENGTH(STO."EventID") - CHAR_LENGTH(REPLACE(STO."EventID", '.', ''))) / CHAR_LENGTH('.')=1
)
select 
* 
,
case when date_part('year',Time_sub_area_start_date2) < 0 then 'Avant An 0'
else 'Après An 0'
end as An_0
from datas as d
where 1=1
	and d.is_last=1
order by d.time_sub_area_start_date2 asc
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
 * Niveau 3 time
 */


drop view arcs.Time_sub_sub_area;
create or replace view arcs.Time_sub_sub_area
as
(
with datas 
as
(
select 
STO."EventID"  as Time_area_id,
STO."Title" as Time_area_name,
case 
	when left(STO."EventID",1) = '1' then   Concat((STO."Start Date"),' BC')::date
	else STO."Start Date" 
end as Time_sub_sub_area_start_date2,
case 
	when left(STO."EventID",1) = '1' then   Concat(STO."End Date",' BC')::date
	else STO."End Date" 
end  as Time_sub_sub_area_end_date2,	
STO."Duration" as Time_area_sub_sub_duration_string,
row_number() over (partition by STO."EventID" order by STO.updated_at desc) as is_last
from public."Story_line" as STO
where 1=1
	and Sto."EventID"  like '%.%'
	and (CHAR_LENGTH(STO."EventID") - CHAR_LENGTH(REPLACE(STO."EventID", '.', ''))) / CHAR_LENGTH('.')=2
)
select 
* 
,
case when date_part('year',Time_sub_sub_area_start_date2) < 0 then 'Avant An 0'
else 'Après An 0'
end as An_0
from datas as d
where 1=1
	and d.is_last=1
order by d.time_sub_sub_area_start_date2 asc
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
 * Niveau 4 time
 */

drop VIEW IF EXISTS  arcs.Time_sub_sub_sub_area;
create or replace view arcs.Time_sub_sub_sub_area
as
(
with datas 
as
(
select 
STO."EventID"  as Time_area_id,
STO."Title" as Time_area_name,
case 
	when left(STO."EventID",1) = '1' then   Concat((STO."Start Date"),' BC')::date
	else STO."Start Date" 
end as Time_sub_area_start_date2,
case 
	when left(STO."EventID",1) = '1' then   Concat(STO."End Date",' BC')::date
	else STO."End Date" 
end  as Time_sub_area_end_date2,	
STO."Duration" as Time_area_sub_duration_string,
STO.Arc,
row_number() over (partition by STO."EventID" order by STO.updated_at desc) as is_last
from public."Story_line" as STO
where 1=1
	and Sto."EventID"  like '%.%'
	and (CHAR_LENGTH(STO."EventID") - CHAR_LENGTH(REPLACE(STO."EventID", '.', ''))) / CHAR_LENGTH('.')=3
)
select 
* 
,
case when date_part('year',Time_sub_area_start_date2) < 0 then 'Avant An 0'
else 'Après An 0'
end as An_0
from datas as d
where 1=1
	and d.is_last=1
order by d.time_sub_area_start_date2 asc
)


/*
 * Table des personnages apparaissants dans la table Aeon
 */


create view personnages.Aeon_personnages_jnt
as
(
with 
Persos
as
(
SELECT unnest(string_to_array(ST."Participant" , '|')) as "A_personnages"
FROM public."Story_line" as ST
) 
,
All_perso_lines
as
(
select distinct "A_personnages" as A_perso_name
from Persos as Ap
)
select
p.personnage_id ,
ALP.A_perso_name,
p."type" ,
r.race_name ,
f.faction_name ,
p.naissance ,
p.mort ,
p.description 
from All_perso_lines as ALP
left join personnages.personnages p 
	on ALP.A_perso_name = unaccent_string(p.nom) 
left join encyclopédie.races r 
	on p.race_id =r.race_id
left join entité.factions f 
	on r.race_faction_id =f.faction_id 
order by p.personnage_id asc
)








