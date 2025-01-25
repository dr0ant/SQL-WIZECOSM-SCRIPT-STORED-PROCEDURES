Create schema wizecrypto;


select
    *
from wizecrypto."f6b65e1e-a9a9-11ef-b3a2-0e7c2122f427-1";


with datas as (select exp."Time"          as date,
                      exp."Pair"          as pair,
                      exp."Order Amount"  as order_token_amount,
                      exp."Average Price" as avg_price,
                      exp."Trading total" as order_USDT_amount
               from wizecrypto."f6b65e1e-a9a9-11ef-b3a2-0e7c2122f427-1" as exp
               where 1 = 1
                 AND exp."Status" = 'FILLED'
                 AND exp."Side" = 'BUY'),
cleaned_data as (select exp.*,
                        REGEXP_REPLACE(exp.order_token_amount, '[^0-9.]', '', 'g') ::float AS TOKEN_AMOUNT,
                        REGEXP_REPLACE(exp.order_USDT_amount, '[^0-9.]', '', 'g') ::float  AS USDT_AMOUNT
                 from datas as exp)
select
REPLACE(REPLACE(REPLACE(cl.pair,'USDT',''),'USDC',''),'TUSD','') as pair_clean,
 SUM(cl.avg_price * cl.TOKEN_AMOUNT) / SUM(cl.TOKEN_AMOUNT) AS avg_price
from cleaned_data as cl
group by pair_clean;


-----------------------------
drop view if exists wizecrypto.vw_volume_open_orders_sell;
create view wizecrypto.vw_volume_open_orders_sell as
(
SELECT *
from (select opo.symbol,
             SUM(opo.price * opo.qty) as sum_per_symbol
      from wizecrypto.current_open_orders_binance as opo
      where opo.side = 'SELL'
      group by opo.symbol
      order by sum_per_symbol desc)
         as A
UNION
select *
from (select '---------TOTAL------',
             SUM(opo.price * opo.qty) as sum_per_symbol
      from wizecrypto.current_open_orders_binance as opo
      where opo.side = 'SELL') as b

order by sum_per_symbol desc
    );


select
*
from wizecrypto.vw_volume_open_orders_sell