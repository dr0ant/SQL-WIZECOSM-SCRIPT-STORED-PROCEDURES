select 
SUM(spends)+500
from 
(
select
case 
	when CHIFF.libele like '%CARREFOUR%' then 'alimentation'
	when CHIFF.libele like '%AMAZON%' then 'AMAZON'
	when CHIFF.libele like '%PROZIS%' then 'PROZIS'
	when CHIFF.libele like '%Total Direct%' or  CHIFF.libele like '%FREE%' or CHIFF.libele like '%PRELEVEMENT%'  then 'Facture'
	when CHIFF.libele like '%FNAC%' then 'FNAC'
	when CHIFF.libele like '%Binance%' then 'Crypto'
	else 'BOUFFE/AUTRE'
end as cat,
SUM(CHIFF.montant) as spends
from public."CMPT_MARS_2021" as CHIFF
group by cat
) as A