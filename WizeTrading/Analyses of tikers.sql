create table wizetrading.raw_data
as (select *
    from wizecosm.test22222)
;

/*
 ticker data binance Doc
      {
        "e": "kline",     // Event type
        "E": 123456789,   // Event time
        "s": "BNBBTC",    // Symbol
        "k": {
          "t": 123400000, // Kline start time-
          "T": 123460000, // Kline close time-
          "s": "BNBBTC",  // Symbol
          "i": "1m",      // Interval-
          "f": 100,       // First trade ID-
          "L": 200,       // Last trade ID-
          "o": "0.0010",  // Open price-
          "c": "0.0020",  // Close price-
          "h": "0.0025",  // High price-
          "l": "0.0015",  // Low price-
          "v": "1000",    // Base asset volume-
          "n": 100,       // Number of trades-
          "x": false,     // Is this kline closed?-
          "q": "1.0000",  // Quote asset volume-
          "V": "500",     // Taker buy base asset volume-
          "Q": "0.500",   // Taker buy quote asset volume-
          "B": "123456"   // Ignore
        }
      }
 */




create table wizetrading.combined_stream_treated
AS(
    select
       stream      :: varchar as stream
       ,"data_e"   :: varchar as event_type
       ,"data_E"   :: bigint as event_time
       ,"data_s"   :: varchar as symbole_src
       ,"data_k_t" :: bigint as candle_open_time
       ,"data_k_T" :: bigint as candle_close_time
       ,"data_k_s" :: varchar as symbole
       ,"data_k_i" :: varchar as interval
       ,"data_k_f" :: int as first_trade_id
       ,"data_k_L" :: int as last_trade_id
       ,"data_k_o" :: decimal as openprice
       ,"data_k_c" :: decimal as close_price
       ,"data_k_h" :: decimal as high_price
       ,"data_k_l" :: decimal as low_price
       ,"data_k_v" :: int as base_asset_volume
       ,"data_k_n" :: int as  nb_trades
       ,"data_k_x" :: boolean as candle_closed
       ,"data_k_q" :: decimal as quote_asset_volume
       ,"data_k_V" :: decimal as taker_buy_base_asset_volume
       ,"data_k_Q" :: decimal as taker_buy_quote_asset_volume
    from wizetrading.raw_data
);
---------------------------------------------------------
create view wizetrading.v_BTCUSD_PERP_5min
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_5m'
    );

create view wizetrading.v_BTCUSD_PERP_15min
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_15m'
    );

create view wizetrading.v_BTCUSD_PERP_1H
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1h'
    );

create view wizetrading.v_BTCUSD_PERP_4H
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_4h'
    );

create view wizetrading.v_BTCUSD_PERP_1D
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1d'
    );

create view wizetrading.v_BTCUSD_PERP_1W
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1w'
    );

------------------------------------------------------------
/* create history candle*/



create view wizetrading.v_BTCUSD_PERP_5min_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_5m'
and candle_closed = true
    );

create view wizetrading.v_BTCUSD_PERP_15min_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_15m'
and candle_closed = true
    );

create view wizetrading.v_BTCUSD_PERP_1H_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1h'
and candle_closed = true
    );

create view wizetrading.v_BTCUSD_PERP_4H_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_4h'
and candle_closed = true
    );

create view wizetrading.v_BTCUSD_PERP_1D_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1d'
and candle_closed = true
    );

create view wizetrading.v_BTCUSD_PERP_1W_history
as
(
select *
from wizetrading.combined_stream_treated
where stream ='btcusd_perp@kline_1w'
and candle_closed = true
    );

------------------------------------------------------------------------
create view wizetrading.v_combined_treated_streams
as
(
select
/*indicators*/
lag(five_min.openprice,1) over (partition by five_min.stream order by five_min.event_time ) as prev_fivemin_openprice,

/*source data*/
five_min.*,
fifteen_min.*,
one_hour.*,
four_hour.*,
one_day.*,
one_week.*
from wizetrading.v_btcusd_perp_5min as five_min
/* link 15 min chart */
         left join wizetrading.v_btcusd_perp_15min as fifteen_min
                   ON five_min.event_time = fifteen_min.event_time
/* link 1h  chart */
         left join wizetrading.v_btcusd_perp_1h as one_hour
                   ON five_min.event_time = one_hour.event_time
/* link 4h  chart */
         left join wizetrading.v_btcusd_perp_4h as four_hour
                   ON five_min.event_time = four_hour.event_time
/* link 1d chart */
         left join wizetrading.v_btcusd_perp_1d as one_day
                   ON five_min.event_time = one_day.event_time
/* link 1w chart */
         left join wizetrading.v_btcusd_perp_1w as one_week
                   ON five_min.event_time = one_week.event_time
order by five_min.event_time
    )
;


------------------------------------------------
select
    TO_CHAR(TO_TIMESTAMP(event_time / 1000), 'YYYY-MM-DD HH24:MI:SS') AS formatted_datetime,
    *
from wizetrading.v_btcusd_perp_5min_history;
-- 1699615 159936

create view wizetrading.candle_5min_current_and_history
    as
(
with current_candle
         as (select TO_CHAR(TO_TIMESTAMP(event_time / 1000), 'YYYY-MM-DD HH24:MI:SS') AS formatted_datetime,
                    *
             from wizetrading.v_btcusd_perp_5min
             where candle_closed = false)
        ,
     history_candles
         as (select TO_CHAR(TO_TIMESTAMP(event_time / 1000), 'YYYY-MM-DD HH24:MI:SS') AS formatted_datetime,
                    *
             from wizetrading.v_btcusd_perp_5min_history),
     pivot_curent
         as
         (select curr.*,
                 lag(hist.openprice, 1) over (partition by curr.event_time order by hist.event_time) as openprice_lag_1,
                 lag(hist.openprice, 2)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_2,
                 lag(hist.openprice, 3)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_3,
                 lag(hist.openprice, 4)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_4,
                 lag(hist.openprice, 5)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_5,
                 lag(hist.openprice, 6)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_6,
                 lag(hist.openprice, 7)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_7,
                 lag(hist.openprice, 8)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_8,
                 lag(hist.openprice, 9)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_9,
                 lag(hist.openprice, 10)
                 over (partition by curr.event_time order by hist.event_time)                        as openprice_lag_10,

                 lag(hist.close_price, 1)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_1,
                 lag(hist.close_price, 2)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_2,
                 lag(hist.close_price, 3)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_3,
                 lag(hist.close_price, 4)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_4,
                 lag(hist.close_price, 5)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_5,
                 lag(hist.close_price, 6)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_6,
                 lag(hist.close_price, 7)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_7,
                 lag(hist.close_price, 8)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_8,
                 lag(hist.close_price, 9)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_9,
                 lag(hist.close_price, 10)
                 over (partition by curr.event_time order by hist.event_time)                        as close_price_lag_10,

                 lag(hist.high_price, 1)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_1,
                 lag(hist.high_price, 2)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_2,
                 lag(hist.high_price, 3)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_3,
                 lag(hist.high_price, 4)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_4,
                 lag(hist.high_price, 5)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_5,
                 lag(hist.high_price, 6)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_6,
                 lag(hist.high_price, 7)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_7,
                 lag(hist.high_price, 8)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_8,
                 lag(hist.high_price, 9)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_9,
                 lag(hist.high_price, 10)
                 over (partition by curr.event_time order by hist.event_time)                        as high_price_lag_10,

                 lag(hist.low_price, 1)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_1,
                 lag(hist.low_price, 2)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_2,
                 lag(hist.low_price, 3)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_3,
                 lag(hist.low_price, 4)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_4,
                 lag(hist.low_price, 5)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_5,
                 lag(hist.low_price, 6)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_6,
                 lag(hist.low_price, 7)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_7,
                 lag(hist.low_price, 8)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_8,
                 lag(hist.low_price, 9)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_9,
                 lag(hist.low_price, 10)
                 over (partition by curr.event_time order by hist.event_time)                        as low_price_lag_10,

                 row_number() over (partition by curr.event_time order by hist.event_time desc )     as rank
          from current_candle as curr
                   left join history_candles as hist
                             on curr.event_time >= hist.event_time
--where curr.event_time = 1699616821827
          order by curr.event_time)
select *
from pivot_curent
where rank = 1
    )
;


select
    *,
    (
            COALESCE(openprice_lag_1, openprice) +
            COALESCE(openprice_lag_2, openprice_lag_1) +
            COALESCE(openprice_lag_3, COALESCE(openprice_lag_2, openprice_lag_1)) +
            COALESCE(openprice_lag_4, COALESCE(openprice_lag_3, COALESCE(openprice_lag_2, openprice_lag_1))) +
            COALESCE(openprice_lag_5,
                     COALESCE(openprice_lag_4, COALESCE(openprice_lag_3, COALESCE(openprice_lag_2, openprice_lag_1))))
        )/5 as avg_last_5_open_price,
        (
            COALESCE(close_price_lag_1, openprice) +
            COALESCE(close_price_lag_2, close_price_lag_1) +
            COALESCE(close_price_lag_3, COALESCE(close_price_lag_2, close_price_lag_1)) +
            COALESCE(close_price_lag_4, COALESCE(close_price_lag_3, COALESCE(close_price_lag_2, close_price_lag_1))) +
            COALESCE(close_price_lag_5,
                     COALESCE(close_price_lag_4, COALESCE(close_price_lag_3, COALESCE(close_price_lag_2, close_price_lag_1))))
        )/5 as avg_last_5_close_price,
        (
            COALESCE(low_price_lag_1, openprice) +
            COALESCE(low_price_lag_2, low_price_lag_1) +
            COALESCE(low_price_lag_3, COALESCE(low_price_lag_2, low_price_lag_1)) +
            COALESCE(low_price_lag_4, COALESCE(low_price_lag_3, COALESCE(low_price_lag_2, low_price_lag_1))) +
            COALESCE(low_price_lag_5,
                     COALESCE(low_price_lag_4, COALESCE(low_price_lag_3, COALESCE(low_price_lag_2, low_price_lag_1))))
        )/5 as avg_last_5_low_price,
        (
            COALESCE(high_price_lag_1, openprice) +
            COALESCE(high_price_lag_2, high_price_lag_1) +
            COALESCE(high_price_lag_3, COALESCE(high_price_lag_2, high_price_lag_1)) +
            COALESCE(high_price_lag_4, COALESCE(high_price_lag_3, COALESCE(high_price_lag_2, high_price_lag_1))) +
            COALESCE(high_price_lag_5,
                     COALESCE(high_price_lag_4, COALESCE(high_price_lag_3, COALESCE(high_price_lag_2, high_price_lag_1))))
        )/5 as avg_last_5_high_price
from wizetrading.candle_5min_current_and_history
where openprice > candle_5min_current_and_history.openprice_lag_1;

-- faire le même exercice pour tous les champs & toutes les timeframe
-- recherche de règle --> moving average ?