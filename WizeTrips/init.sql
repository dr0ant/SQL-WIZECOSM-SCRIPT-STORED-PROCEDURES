-- create new schema
create schema IF NOT EXISTS wizetrips;


-- create table dédicated to trips
drop table if exists wizetrips.trips;
CREATE TABLE IF NOT EXISTS wizetrips.trips(
    trip_id SERIAL PRIMARY KEY,
    trip_name VARCHAR,
    trip_start_date DATE,
    trip_end_date DATE,
    trip_date DATE,
    trip_budget FLOAT,
    trip_budget_currency VARCHAR,
    trip_daily_place varchar,
    activity_booked BOOLEAN,
    activities VARCHAR,
    activities_links VARCHAR,
    activities_price FLOAT,
    activities_currency VARCHAR,
    stay_booked BOOLEAN,
    stay VARCHAR,
    stay_links VARCHAR,
    stay_price FLOAT,
    stay_currency VARCHAR
);

-- add constraint to the table
ALTER TABLE wizetrips.trips
ADD CONSTRAINT trips_unique_constraint UNIQUE (trip_name, trip_date);



-- store procedure to initialize the trip
CREATE OR REPLACE FUNCTION wizetrips.insert_trip_data(
    trip_name_param VARCHAR,
    trip_start_date_param DATE,
    trip_end_date_param DATE,
    trip_budget_param FLOAT,
    trip_budget_currency_param VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Insert or update data for each date between trip_start_date - 3 days and trip_end_date + 3 days
    INSERT INTO wizetrips.trips(trip_name, trip_start_date, trip_end_date, trip_date, trip_budget, trip_budget_currency)
    SELECT
        trip_name_param,
        trip_start_date_param,
        trip_end_date_param,
        dm.date,
        trip_budget_param,
        trip_budget_currency_param
    FROM
        public.dates_months dm
    WHERE
        dm.date >= trip_start_date_param - interval '3 days'
        AND dm.date <= trip_end_date_param + interval '3 days'
    ON CONFLICT (trip_name, trip_date) DO UPDATE
    SET
        trip_start_date = EXCLUDED.trip_start_date,
        trip_end_date = EXCLUDED.trip_end_date,
        trip_budget = EXCLUDED.trip_budget,
        trip_budget_currency = EXCLUDED.trip_budget_currency;
END;
$$ LANGUAGE plpgsql;

select * from
        public.dates_months dm
    WHERE
        dm.date >= '2024-05-15'::date - interval '3 days'
        AND dm.date <= '2024-06-01'::date + interval '3 days'
;

-- test store procedure 1
select wizetrips.insert_trip_data('Japan Trip 2024','2024-05-15','2024-06-01',1500.0,'EUR');

-- fill in daily place

CREATE OR REPLACE FUNCTION wizetrips.update_trip_daily_place(
    trip_date_param DATE,
    trip_name_param VARCHAR,
    trip_daily_place_param VARCHAR,
    home_param VARCHAR
) RETURNS VOID AS $$
BEGIN
    UPDATE wizetrips.trips
    SET trip_daily_place =
        CASE
            WHEN trip_date = trip_date_param THEN trip_daily_place_param
            WHEN trip_date < (SELECT trip_start_date FROM wizetrips.trips WHERE trip_date = trip_date_param AND trip_name = trip_name_param) THEN home_param
            WHEN trip_date > (SELECT trip_end_date FROM wizetrips.trips WHERE trip_date = trip_date_param AND trip_name = trip_name_param) THEN home_param
            ELSE trip_daily_place
        END
    WHERE trip_name = trip_name_param;
END;
$$ LANGUAGE plpgsql;

-- test store procedure
select wizetrips.update_trip_daily_place(
    '2024-05-21',
    'Japan Trip 2024',
    'Okinawa',
    'Geneva'
    );

-- add all places
SELECT wizetrips.update_trip_daily_place('2024-05-15', 'Japan Trip 2024', 'Genève-Beijing', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-16', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-17', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-18', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-19', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-20', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-21', 'Japan Trip 2024', 'Okinawa', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-22', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-23', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-24', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-25', 'Japan Trip 2024', 'Osaka', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-26', 'Japan Trip 2024', 'Osaka', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-27', 'Japan Trip 2024', 'Kyoto', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-28', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-29', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-30', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-05-31', 'Japan Trip 2024', 'Tokyo', 'Geneva');
SELECT wizetrips.update_trip_daily_place('2024-06-01', 'Japan Trip 2024', 'Geneva-Beijing', 'Geneva');


-- add stay info store procedure

CREATE OR REPLACE FUNCTION wizetrips.update_trip_stay_info(
    trip_name_param VARCHAR,
    trip_date_param DATE,
    stay_booked_param BOOLEAN,
    stay_param VARCHAR,
    stay_links_param VARCHAR,
    stay_price_param FLOAT,
    stay_currency_param VARCHAR
) RETURNS VOID AS $$
BEGIN
    UPDATE wizetrips.trips
    SET
        stay_booked = stay_booked_param,
        stay = stay_param,
        stay_links = stay_links_param,
        stay_price = stay_price_param,
        stay_currency = stay_currency_param
    WHERE
        trip_name = trip_name_param
        AND trip_date = trip_date_param;
END;
$$ LANGUAGE plpgsql;

SELECT wizetrips.update_trip_stay_info('Japan Trip 2024', '2024-05-15', FALSE, 'Genève-Beijing', NULL, NULL, NULL);


-- execute the update with a loop :

-- Iterate through each row of the provided data and update stay information
DO $$
DECLARE
    trip_record RECORD;
BEGIN
    FOR trip_record IN
        SELECT * FROM (VALUES
            ('Japan Trip 2024', '2024-05-15', FALSE, 'Genève-Beijing', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-16', TRUE, 'Tokyo (Wise Owl Hostels River)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-17', TRUE, 'Tokyo (Wise Owl Hostels River)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-18', TRUE, 'Tokyo (Wise Owl Hostels River)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-19', TRUE, 'Tokyo (Wise Owl Hostels River)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-20', FALSE, 'Tokyo', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-21', TRUE, 'Okinawa (The Grand Hotel 3 5 1)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-22', FALSE, 'Tokyo', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-23', FALSE, 'Tokyo', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-24', FALSE, 'Tokyo', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-25', FALSE, 'Osaka', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-26', FALSE, 'Osaka', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-27', FALSE, 'Kyoto', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-28', FALSE, 'Tokyo', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-29', TRUE, 'Tokyo (Ici japon village)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-30', TRUE, 'Tokyo (Ici japon village)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-05-31', FALSE, 'Tokyo (Transit Beijing)', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR),
            ('Japan Trip 2024', '2024-06-01', FALSE, 'Beijing-Genève', NULL::VARCHAR, NULL::FLOAT, NULL::VARCHAR)
        ) AS data(trip_name, trip_date, stay_booked, stay, stay_links, stay_price, stay_currency)
    LOOP
        PERFORM wizetrips.update_trip_stay_info(
            trip_record.trip_name,
            trip_record.trip_date::DATE,
            trip_record.stay_booked,
            trip_record.stay,
            trip_record.stay_links,
            trip_record.stay_price,
            trip_record.stay_currency
        );
    END LOOP;
END$$;

-- add underlying tables
drop table if exists wizetrips.stays ;
CREATE TABLE IF NOT EXISTS wizetrips.stays (
    stay_id SERIAL PRIMARY KEY,
    trip_name varchar ,
    stay_date DATE,
    stay_name VARCHAR,
    stay_links VARCHAR,
    stay_price FLOAT,
    stay_currency VARCHAR
);

drop table if exists wizetrips.activities;
CREATE TABLE IF NOT EXISTS wizetrips.activities (
    activity_id SERIAL PRIMARY KEY,
    trip_name varchar ,
    activity_date DATE,
    activity_name VARCHAR,
    activity_links VARCHAR,
    activity_price FLOAT,
    activity_currency VARCHAR
);

-- Add composite unique constraint for stays table
ALTER TABLE wizetrips.stays
ADD CONSTRAINT unique_stay_key UNIQUE (trip_name, stay_date, stay_name);

-- Add composite unique constraint for activities table
ALTER TABLE wizetrips.activities
ADD CONSTRAINT unique_activity_key UNIQUE (trip_name, activity_date, activity_name);

-- Stored Procedure for Inserting/Updating Stay Information
CREATE OR REPLACE FUNCTION wizetrips.insert_update_stay(
    trip_name_param VARCHAR,
    stay_date_param DATE,
    stay_name_param VARCHAR,
    stay_links_param VARCHAR,
    stay_price_param FLOAT,
    stay_currency_param VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO wizetrips.stays (trip_name, stay_date, stay_name, stay_links, stay_price, stay_currency)
    VALUES (trip_name_param, stay_date_param, stay_name_param, stay_links_param, stay_price_param, stay_currency_param)
    ON CONFLICT (trip_name, stay_date, stay_name) DO UPDATE
    SET
        stay_links = EXCLUDED.stay_links,
        stay_price = EXCLUDED.stay_price,
        stay_currency = EXCLUDED.stay_currency;
END;
$$ LANGUAGE plpgsql;

-- Stored Procedure for Inserting/Updating Activities
CREATE OR REPLACE FUNCTION wizetrips.insert_update_activity(
    trip_name_param VARCHAR,
    activity_date_param DATE,
    activity_name_param VARCHAR,
    activity_links_param VARCHAR,
    activity_price_param FLOAT,
    activity_currency_param VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO wizetrips.activities (trip_name, activity_date, activity_name, activity_links, activity_price, activity_currency)
    VALUES (trip_name_param, activity_date_param, activity_name_param, activity_links_param, activity_price_param, activity_currency_param)
    ON CONFLICT (trip_name, activity_date, activity_name) DO UPDATE
    SET
        activity_links = EXCLUDED.activity_links,
        activity_price = EXCLUDED.activity_price,
        activity_currency = EXCLUDED.activity_currency;
END;
$$ LANGUAGE plpgsql;



-- Select statement to fetch stay information for the arrival date
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-29',
    'Ici Japon Village',
    NULL,
    10000,
    'JPY'
);

-- Select statement to fetch stay information for the departure date
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-30',
    'Ici Japon Village',
    NULL,
    10000,
    'JPY'
);

-- Select statement for the check-in date
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-16',
    'Wise Owl Hostels River Tokyo',
    NULL,
    3800,
    'JPY'
);

-- Select statement for the second day of stay
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-17',
    'Wise Owl Hostels River Tokyo',
    NULL,
    4500,
    'JPY'
);

-- Select statement for the third day of stay
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-18',
    'Wise Owl Hostels River Tokyo',
    NULL,
    5700,
    'JPY'
);

-- Select statement for the stay at The Grand Hotel Ginowan
SELECT * FROM wizetrips.insert_update_stay(
    'Tokyo Trip 2024',
    '2024-05-21',
    'The Grand Hotel Ginowan',
    NULL,
    45.11,
    'CHF'
);

SELECT * FROM wizetrips.insert_update_stay(
    'Asakusa View Hotel' ,
    '2024-05-28' ,
    'Standard Double Skytree View Smoking' ,
    'https://www.viewhotels.co.jp/asakusa/english/' ,
    24902 ,
    'JPY' );

-----------------------------
drop view if exists wizetrips.stay_costs;
Create or replace view wizetrips.stay_costs as
    select
        trip_name,
        stay_currency,
        SUM(stay_price) as total_spend
    from wizetrips.stays
group by trip_name,
        stay_currency

