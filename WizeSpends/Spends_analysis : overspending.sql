-- Creating a Table Dates
drop table if exists public.dates_months;
Create table public.dates_months
as
    (WITH date_range AS (SELECT generate_series('2023-01-01'::date, '2030-12-31'::date, '1 day') AS date),
          dates_with_info AS (SELECT date,
                                     EXTRACT(MONTH FROM date)                                                   AS month,
                                     EXTRACT(DAY FROM date)                                                     AS day_of_month,
                                     EXTRACT(DAYS FROM DATE_TRUNC('MONTH', date) + INTERVAL '1 MONTH' -
                                                       INTERVAL '1 DAY')                                        AS days_in_month,
                                     EXTRACT(DAYS FROM
                                             DATE_TRUNC('MONTH', date + INTERVAL '1 DAY') + INTERVAL '1 MONTH' -
                                             INTERVAL '1 DAY')                                                  AS days_in_following_month
                              FROM date_range)
     SELECT date,
            month,
            days_in_month
     FROM dates_with_info);






-- reformating the date table to chose the starting periode

drop table public.dates_months_shifted CASCADE;
CREATE TABLE public.dates_months_shifted
AS
  (WITH date_range AS (
      SELECT generate_series('2023-01-01'::date, '2030-12-31'::date, '1 day') AS date
    ),
    dates_with_info AS (
      SELECT date,
             EXTRACT(MONTH FROM date + INTERVAL '1 MONTH') AS month, -- Shifted month to the next month
             EXTRACT(DAY FROM date) AS day_of_month,
             EXTRACT(DAYS FROM DATE_TRUNC('MONTH', date) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') AS days_in_month, -- Days in current month
             EXTRACT(DAYS FROM DATE_TRUNC('MONTH', date)) AS days_in_prev_month -- Days in preceding month
      FROM date_range
    ),
    shifted_dates AS (
      SELECT date + INTERVAL '26 days' AS date_shifted,
             month,
             days_in_prev_month,
             days_in_month
      FROM dates_with_info
    )
   SELECT date_shifted AS date,
          month,
          days_in_prev_month AS days_in_month
   FROM shifted_dates);

WITH DATAs AS (
    SELECT DISTINCT month, days_in_month
    FROM dates_months
    WHERE days_in_month <> 29
)
UPDATE public.dates_months_shifted AS dms
SET days_in_month = ds.days_in_month
FROM DATAs AS ds
WHERE ds.month = dms.month;


    ALTER TABLE public.dates_months_shifted
ADD COLUMN n_day_of_the_month INTEGER;

UPDATE public.dates_months_shifted AS dms
SET n_day_of_the_month = dn.day_number
FROM (
    SELECT date,
           ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM date), month ORDER BY date) AS day_number
    FROM public.dates_months_shifted
) AS dn
WHERE dms.date = dn.date;




-- defining the function :

drop view IF EXISTS wizespends.Overspend_Underspend;
Create view  wizespends.Overspend_Underspend
AS (
    WITH daily_info AS (
    SELECT
    date::date AS date,
    days_in_month,
    n_day_of_the_month,
    EXTRACT (DAY FROM date::date) AS day_of_the_month,
    (days_in_month + 1) - n_day_of_the_month AS nb_of_day_last,
    1400 AS amount_to_spend_in_a_month,
    1400 / (days_in_month + 2 ) AS daily_spend_in_month
    FROM
    dates_months_shifted
)
    SELECT
    date as _date,
    day_of_the_month,
    nb_of_day_last,
    amount_to_spend_in_a_month,
    daily_spend_in_month,
    amount_to_spend_in_a_month - (n_day_of_the_month * daily_spend_in_month) as rest_to_use
    FROM
    daily_info
);


/*
select * from wizespends.Overspend_Underspend
where date  between  '2024-01-01':: date and '2025-04-27':: date
;
*/

drop function if exists wizespends.did_I_overSpend(actual_amount_param int);
CREATE OR REPLACE FUNCTION wizespends.did_I_overSpend(actual_amount_param int)
RETURNS TABLE (
    date_today date,
    actual_amount int,
    suposed_amount float,
    over_spent_amount varchar
) AS
$$
DECLARE
    -- Declare local variables
    over_spent int;
BEGIN
    -- Calculate over-spending
    SELECT
        wizespends.overspend_underspend._date as date_today,
        actual_amount_param AS actual_amount, -- Assigning the parameter to a local variable
        rest_to_use AS suposed_amount,
        CASE
            WHEN rest_to_use < actual_amount_param THEN 'UNDERSPEND ' || TO_CHAR(actual_amount_param - rest_to_use, '9999999')
            WHEN rest_to_use > actual_amount_param THEN 'OVERSPEND ' || TO_CHAR(actual_amount_param - rest_to_use, '9999999')
        END AS over_spent_amount
    INTO
        date_today,
        actual_amount,
        suposed_amount,
        over_spent_amount

    FROM
        wizespends.overspend_underspend
    WHERE
        _date = CURRENT_DATE;

    RETURN NEXT;
END;
$$
LANGUAGE plpgsql;


SELECT * FROM wizespends.did_I_overSpend(1239);

