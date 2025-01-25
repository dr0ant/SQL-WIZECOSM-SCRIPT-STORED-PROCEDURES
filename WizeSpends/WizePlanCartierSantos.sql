create table wizespends.plan_cartier_santos
(
    id serial,
    date date,
    actual_amount int,
    supposed_amount int
);

truncate  wizespends.plan_cartier_santos;

-- Insert data with increments for the supposed_amount
INSERT INTO wizespends.plan_cartier_santos (date, actual_amount, supposed_amount)
VALUES
    ('2024-09-25', 0, 450),
    ('2024-10-25', 0, 1450),
    ('2024-11-25', 0, 2450),
    ('2024-12-25', 0, 3450),
    ('2025-01-25', 0, 4450),
    ('2025-02-25', 0, 5450),
    ('2025-03-25', 0, 6450),
    ('2025-04-25', 0, 7450);


select * from wizespends.plan_cartier_santos;

CREATE OR REPLACE PROCEDURE wizespends.update_actual_amount(new_amount INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE wizespends.plan_cartier_santos
    SET actual_amount = new_amount
    WHERE EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM NOW());
END;
$$;

CALL wizespends.update_actual_amount(3800);


select
    *
from wizespends.plan_cartier_santos
order by date asc ;

UPDATE wizespends.plan_cartier_santos
SET actual_amount = NULL
WHERE actual_amount = 0;


create or replace view wizespends.vw_plan_cartier_santos
as
select
date as d_date,
supposed_amount,
actual_amount ,
(actual_amount*1.00/ 7450 ) as  objective_percent,
7450 - actual_amount as remaning_amount,
1- (actual_amount*1.00/ 7450 )  as remaining_percent
from  wizespends.plan_cartier_santos