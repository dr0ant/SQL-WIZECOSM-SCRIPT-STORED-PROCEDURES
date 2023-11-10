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