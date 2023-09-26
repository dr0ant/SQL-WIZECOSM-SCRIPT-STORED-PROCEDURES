create table wizespends.spends_swizerland_september
as (select TO_DATE("        Date", 'DD.MM.YY') as date,
           "Libellé"                           as libelle,
           "Montant"::float                    as montant,
           "Valeur"                            as valeur
    from wizespends."IMP_Releve_compte Suisse_24082023_to_26092023" imp);;
-------------------------

-- list top 10 gros achats > 100 chf

select
    *
from wizespends.spends_swizerland_september

where montant <= -100
limit 10;

---------------------------
-- achat lunettes 200 chf
-- loyer 1400 CHF
-- achat plex 115 chf
-- virement vers compte fr 1600 chf


-- spends by label
select
Replace(LEFT(Replace(libelle,'Achat Mastercard -',''),position('-' in replace(libelle,'Achat Mastercard -','') )),'-','') as libelle,
sum(montant) as sum_by_store
from wizespends.spends_swizerland_september
where libelle not like '%Crédit%'
and libelle not like '%Ordre%'
and libelle not like '%Virement%'
group by Replace(LEFT(Replace(libelle,'Achat Mastercard -',''),position('-' in replace(libelle,'Achat Mastercard -','') )),'-','')
order by sum_by_store asc;

with datas as (select date,
                      sum(montant) as daily_spend
               from wizespends.spends_swizerland_september
               where libelle not like '%Crédit%'
                 and libelle not like '%Ordre%'
                 and libelle not like '%Virement%'
               group by date)
select
    avg(daily_spend),
    --median(daily_spend),
    sum(daily_spend)
from datas

-- dépense totale 1400 chf

-- dépense moyenne par jour 78 chf