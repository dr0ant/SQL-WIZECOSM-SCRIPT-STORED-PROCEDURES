-----------------------------------------------

/*SCHEMAS*/

create schema personnages;
create schema geographie;
create schema Arcs;
create schema stats_perso;
create schema tmp;
create schema "row";
create schema entité;
create schema encyclopédie;

/*MAIN tables*/

/*TABLE DES PERSONNAGES*/
create table personnages.personnages
(
   personnage_id SERIAL PRIMARY KEY,
   nom varchar(500),
   "type" varchar(100),
   naissance date,
   mort date,
   description varchar(5000)
)
;

ALTER TABLE personnages.personnages
add COLUMN race_id int ;

select * from personnages.personnages;

/*insertion des 17 premiers perso avec date de naissance aléatoire en fonction de hank*/


insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
values (default,'Hank','personnage principal','600-01-12','6060-09-16', NULL)

insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
 (default,'Atriak','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL)
 
insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
 (default,'Liséa','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL),
 (default,'Kiesh','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL),
 (default,'Ychan','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL)
 
 
  insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
 (default,'Jeanne','personnage principal',date('0600-01-12') + interval '1' day*random_between(+43*365+random_between(20,100),+43*365+random_between(20,100)),NULL,NULL),
 (default,'Taneï','personnage principal',date('0600-01-12') + interval '1' day*random_between(+43*365+random_between(20,100),+43*365+random_between(20,100)),NULL,NULL),
 (default,'Oko','personnage principal',date('0600-01-12') + interval '1' day*random_between(+43*365+random_between(20,100),+43*365+random_between(20,100)),NULL,NULL)
 
 insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
(default,'Bhaus','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL),
  (default,'Ydris','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL)
  
  insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
(default,'Strya','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL),
  (default,'Toël','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL)
  
insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description)
VALUES 
 (default,'Ychan','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-5*365,5*365),NULL,NULL) ,
 (default,'Liséa','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-5*365,5*365),NULL,NULL) ,
 (default,'Kiesh','personnage secondaire',date('0600-01-12') + interval '1' day*random_between(-7*365,7*365),NULL,NULL) 
  
delete from personnages.personnages 
where 1=1
	and personnage_id in(24,25)
	
insert into personnages.personnages (personnage_id,nom,"type",naissance,mort,description,race_id)
VALUES 
 (default,'Riaec','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,7),
 (default,'Gorbah','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,4),
 (default,'Bash','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,5),
 (default,'Java','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,2),
 (default,'Saulh','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,4),
 (default,'Ashir','MLC',date('0600-01-12') + interval '1' day*random_between(-3*365,3*365),NULL,NULL,6)
 ;;;;;;
 
  /* TABLE SPECIFIQUE MLC   */
  drop table if exists personnages.mainlandCosm;
  create table personnages.mainlandCosm
  (
  duo_id int,
  duo_region_id int,
  duo_name varchar(200),
  duo_character_id int,
  duo_rank int
  )
  
  delete from  personnages.mainlandCosm where 1=1;
  Insert into personnages.mainlandCosm (duo_id,duo_region_id,duo_name,duo_character_id,duo_rank)
  values
  (1,null,null,16,1),
  (1,null,null,17,1),
  (2,null,null,18,2),
  (2,null,null,19,2),
  (3,null,null,null,3),
  (3,null,null,null,3),
  (4,null,null,null,4),
  (4,null,null,null,4),
  (5,null,null,null,5),
  (5,null,null,null,5)
  
  select * from personnages.mainlandcosm order by duo_id asc ;
  
  
  /* TABLE DES ARC */
  create table arcs.préhistoire_Arc
  (
  preArc_id  SERIAL PRIMARY key,
  preArc_type varchar(50),
  preArc_name varchar(500),
  preArc_start_date date,
  preArc_end_date date,
  preArc_personnages varchar(5000), --format : |perso1|perso2|...|persoX|)
  preArc_description varchar(5000)
  )
  ;;;
  
  create table arcs.Arc
  (
  Arc_id  SERIAL PRIMARY key,
  Arc_type varchar(50),
  Arc_name varchar(500),
  Arc_start_date date,
  Arc_end_date date,
  Arc_personnages varchar(5000), --format : |perso1|perso2|...|persoX|)
  Arc_description varchar(5000)
  )
  
  select * from arcs.Arc
  
  /* INSERTION DES ARCS */
  
  insert into arcs.Arc (Arc_id  , Arc_type ,Arc_name ,Arc_start_date,Arc_end_date, Arc_personnages , Arc_description )
  values 
(default, 'phase', 'Fin de la guerre fin du cauchemar', '23/05/0641',  '05/01/0643',  NULL,  NULL),
(default, 'phase', 'Fray une contrée paisible', '03/02/0654', '15/02/0656',  NULL,  NULL),
(default, 'phase', 'Pluie détoiles', '15/05/0656',  '23/08/0656',  NULL,  NULL),
(default, 'phase', 'Un voyage en vue',  '27/10/0656',  '25/01/0657',  NULL,  NULL),
(default, 'arc', 'Le voyage de Hank', '26/01/0657' , '16/09/0660' , NULL,  NULL),
(default, 'phase', 'Voyage funeste',  '15/11/0660' , '25/11/0660',  NULL,  NULL),
(default, 'phase', 'Trois destins', '26/11/0660' , '16/12/0660' , NULL,  NULL),
(default, 'arc', 'Tournois des Cosmers',  '17/12/0660' , '16/04/0661', NULL,  NULL),
(default, 'phase', 'Elevation & conflits',  '02/11/0661' , '01/01/0662' , NULL,  NULL),
(default, 'arc', 'Croisade & Noirceur', '01/04/0662' , '18/10/0662',  NULL,  NULL),
(default, 'phase', 'Phenix Noir', '19/10/0662' , '18/12/0662' , NULL,  NULL),
(default, 'arc', 'Retour en îles emergées', '28/03/0663' , '27/03/0664' , NULL,  NULL),
(default, 'phase', 'La conquète de Plénitude',  '28/03/0664' , '17/04/0664' , NULL,  NULL),
(default, 'arc', 'Une alliance',  '06/06/0664' , '07/01/0665' , NULL,  NULL),
(default, 'phase', 'Histoire & légendes du passé', '08/01/0665',  '21/02/0665' , NULL,  NULL),
(default, 'arc', 'Guerre finale', '22/04/0665' , '28/12/0665' , NULL,  NULL),
(default, 'phase', 'Sacrifices & pertes', '29/12/0665' , '10/01/0666' , NULL,  NULL),
(default, 'phase', 'Révélations & origine du Cosm', '22/01/0666' , '27/04/0666' , NULL,  NULL)
  

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

create table entité.factions
(faction_id SERIAL PRIMARY key,
faction_name varchar(500)
)
;
insert into entité.factions (faction_id,faction_name)
values
(default,'Yamé'),
(default,'Gamé')



---------------------------------------------------------------------------------------------------
/* TABLE CONTINENTS */

create table geographie.continent
(
   continent_id SERIAL PRIMARY key,
   continent_name varchar(100),
   continent_category varchar(100),
   continent_is_under_water boolean
)

insert into geographie.continent (continent_id,continent_name,continent_category,continent_is_under_water)
values
(default,'Armathie','historique',false),
(default,'Aldisill','historique',false),
(default,'Kritia','historique',false),
(default,'Abysses de N yla','historique',true),
(default,'Abysses de Ktana','historique',true),
(default,'Kramargue','historique',false),
(default,'L Archipel Emergé','new',false)
  
select * from geographie.continent;

/* TABLE PAYS */

drop table if exists  geographie.pays;
create table geographie.pays
(pays_id SERIAL PRIMARY key,
pays_capitale varchar(500),
pays_continent_id int,
pays_name varchar(50),
pays_faction_id int,
pays_position_x_y varchar(50)
)

insert into geographie.pays (pays_id,
pays_capitale,
pays_continent_id,
pays_name,
pays_faction_id,
pays_position_x_y)
values 
(default,'Glötham',1,null,0,null),
(default,'Helboug',2,null,2,null),
(default,'Merketh',3,null,1,null),
(default,'Frillion',4,null,1,null),
(default,'Frittion',5,null,2,null),
(default,'Sekmeth',3,null,2,null),
(default,'Ahometh',3,null,2,null),
(default,'Crork',6,null,1,null),
(default,'Garok',6,null,1,null),
(default,'Irameth',3,null,1,null),
(default,'Naketh',3,null,2,null),
(default,'Franball',2,null,2,null),
(default,'Akoray',2,null,2,null),
(default,'Fray',1,null,1,null),
(default,'Akÿl',1,null,1,null),
(default,'Koma',1,null,1,null),
(default,'Raki',7,null,1,null),
(default,'Daki',7,null,2,null),
(default,'Aki',7,null,2,null)


 ;;;;;;

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

/* TABLES D'ENTITE */

create table entité.culte
(culte_id SERIAL PRIMARY key,
Culte_name varchar(200),
Culte_faction_id int,
Culte_description varchar(5000)
)

;;

create table entité.pouvoir
(
pouvoir_id SERIAL primary key,
pouvoir_name varchar(500),
pouvoir_faction_id int,
pouvoir_description varchar(500)
)

;;

create table entité.legendes
(
legendes_id SERIAL primary key,
legendes_name varchar(500),
legendes_faction_id int,
legendes_description varchar(500)
)
;;
drop table if exists entité.état_du_monde;
create table entité.état_du_monde
(
monde_id serial primary key,
monde_name varchar(500),
monde_start_date date,
monde_end_date date,
monde_cosm_level float,
monde_total_population int8,
monde_est_en_guerre bool
)
;




/* TABLE DENCLYCLOPEDIE */
drop table if exists encyclopédie.monstres;
create table encyclopédie.monstres
(
monstre_id SERIAL primary key,
monstre_name varchar(500),
monstre_description varchar(5000),
monstre_rank int,
monstre_is_cosm_monster bool
)

;;
drop table if exists encyclopédie.materiaux;
create table encyclopédie.materiaux
(
materiaux_id SERIAL primary key,
materiaux_name varchar(500),
materiaux_description varchar(5000),
materiaux_rank int,
materiaux_categorie varchar(500)
)
;;




drop table if exists encyclopédie.armes;
create table encyclopédie.armes
(arme_id serial primary key,
arme_name varchar(500),
arme_materiaux varchar(1000),
arme_creation_date date,
arme_is_legendaire bool,
arme_rank int
)

drop table if exists encyclopédie.pierres_légendaires;
create table encyclopédie.pierres_légendaires
(pierre_id serial primary key,
pierre_name varchar(50),
pierre_matériaux varchar(1000),
pierre_description varchar(5000),
pierre_created_by_name varchar(500)
)

insert into encyclopédie.pierres_légendaires(pierre_id,
pierre_name,
pierre_matériaux,
pierre_description,
pierre_created_by_name)
values
(default,'Pierre du Soleil','Or|Sang',null,'Solaris'),
(default,'Jade de l abysse','Minerai Algue Ancestrale',null,'Phoséidiens Anciens'),
(default,'Goutte Infinie','Rubis|Souffle infini',null,'Scrimiens'),
(default,'Lune Sans Nom','Agathe|Météroïte noire',null,'Moongriens'),
(default,'Sablié figé','Glace Infinie|Lave volcanique',null,'Plébiniens'),
(default,'Griffe Rose','Saphir|Griffe de créature',null,'Shamaouis')

;;

drop table if exists encyclopédie.peuples;
create table encyclopédie.peuples
(peuple_id serial primary key,
peuple_name varchar(500),
peuple_description varchar(5000),
peuple_artefacts varchar(500)
)


;;


drop table if exists encyclopédie.races;
create table encyclopédie.races
(race_id serial primary key,
race_name varchar(500),
race_description varchar(1000),
race_repartition float,
race_main_continent_id int,
race_faction_id int
)

insert into encyclopédie.races (race_id,
race_name,
race_description,
race_repartition,
race_main_continent_id,
race_faction_id)
values 
(default,'Humains',null,0.075,1,1),
(default,'Humains',null,0.075,3,1),
--15
(default,'Fustillisiens',null,0.10,2,2),
--25
(default,'Orcs',null,0.20,6,1),
--45
(default,'Phoséidiens',null,0.10,4,1),
--55
(default,'Phoséidiens',null,0.10,5,2),
--65
(default,'Nains',null,0.15,6,1),
--90
(default,'Elfs de l Arbre',null,0.10,2,2),
--100
(default,'Sar Elfs',null,0.10,2,2)

select SUM(race_repartition)
from encyclopédie.races 

;;





INSERT INTO encyclopédie.monstres
(monstre_name, monstre_description, monstre_rank, monstre_is_cosm_monster)
VALUES('', '', 0, false);













  
 