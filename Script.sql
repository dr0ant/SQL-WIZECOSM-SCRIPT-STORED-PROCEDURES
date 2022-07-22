create view
arcs.v_tbl_ARCS_AND_PHASES_LINKS
as
(
with 
DATAS
as
(
select 
SL."EventID" ,
SL."Title" ,
SL."Links" ,
SL."Participant" ,
SL.created_at ,
row_number () over (partition by SL."EventID" order by SL.created_at DESC) as NB
from public."Story_line" as SL
)
select 
*
from DATAS 
where 1=1
	and datas.nb=1
)