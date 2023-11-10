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

------------------------------------------------------------------------
create view wizetrading.v_combined_treated_streams
as
(
select
/*indicators*/


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
    )
;


