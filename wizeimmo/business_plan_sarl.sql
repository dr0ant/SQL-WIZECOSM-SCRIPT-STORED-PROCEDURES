drop table if exists wizeimmo.sarl_properties;
create table wizeimmo.sarl_properties
(
    id SERIAL PRIMARY KEY,
    property_name VARCHAR(255) ,
    property_address VARCHAR(255),
    purchase_price DECIMAL(15, 2),
    notarial_fees DECIMAL(15, 2),
    surface DECIMAL(10, 2),
    house_work_amount DECIMAL(15, 2),
    yearly_tax  DECIMAL(15, 2),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
;
-- Make sure property_name has a unique constraint
ALTER TABLE wizeimmo.sarl_properties
ADD CONSTRAINT unique_property_name UNIQUE (property_name);

-- Procedure using ON CONFLICT
CREATE OR REPLACE PROCEDURE upsert_property(
    p_property_name VARCHAR,
    p_property_address VARCHAR,
    p_purchase_price DECIMAL,
    p_notarial_fees DECIMAL,
    p_yearly_tax DECIMAL,
    p_surface DECIMAL,
    p_house_work_amount DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO wizeimmo.sarl_properties (
        property_name, property_address, purchase_price,
        notarial_fees, yearly_tax, surface, house_work_amount, added_date
    ) VALUES (
        p_property_name, p_property_address, p_purchase_price,
        p_notarial_fees,p_yearly_tax, p_surface, p_house_work_amount, CURRENT_TIMESTAMP
    )
    ON CONFLICT (property_name)
    DO UPDATE SET
        property_address = EXCLUDED.property_address,
        purchase_price = EXCLUDED.purchase_price,
        notarial_fees = EXCLUDED.notarial_fees,
        yearly_tax =  EXCLUDED.yearly_tax,
        surface = EXCLUDED.surface,
        house_work_amount = EXCLUDED.house_work_amount,
        updated_date = CURRENT_TIMESTAMP;
END;
$$;

CALL upsert_property(
    'PREBENDE',
    '105 rue d  Entraigues 37000 TOURS  12 ',
    150000,
    150000*0.08,
1135,
    55.5,
    (400+ 800+500+5000)
);

CALL upsert_property(
    'VELPEAU',
    '58 Rue Docteur Fournier Velpeau 37000 Tours',
    138700,
    138700*0.08,
    521,
    36.5,
    (400+100+200+1500+500+200+2000)
);

CALL upsert_property(
    'MIRABAU',
    'xxxxxxx Mirabau',
    155000,
    0.08*155000,
    1174,-- tax fonciere
    57.5,
    (4000+2500+1000+2500+5000)
);


select *  from wizeimmo.sarl_properties;



-- TOTAL ESTIMATED COST
select * from (select property_name,
                      (purchase_price + sarl_properties.notarial_fees +
                       sarl_properties.house_work_amount) as total_project_cost
               from wizeimmo.sarl_properties)
UNION
select * from (
select 'TOTAL' as proprertiy_name,sum((purchase_price + sarl_properties.notarial_fees +
                       sarl_properties.house_work_amount))
               from wizeimmo.sarl_properties)
order by total_project_cost asc;


-----------------------------------------------------
ALTER TABLE wizeimmo.loan_schedule_temp
ADD CONSTRAINT loan_schedule_unique_constraint
UNIQUE (project_name, year_nb, year, month);


CREATE OR REPLACE PROCEDURE generate_loan_schedule(
    p_project_name VARCHAR,
    p_start_date DATE,
    p_duration_months INT,
    p_annual_rate DECIMAL,
    total_amount DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- Variables for amortization calculations
    monthly_rate DECIMAL := p_annual_rate / 12 / 100; -- Monthly interest rate
    monthly_payment DECIMAL;                          -- Monthly payment amount
    remaining_balance DECIMAL := total_amount;        -- Initial balance to pay, from INOUT parameter
    i INT := 0;                                       -- Loop counter for months
    payment_date DATE := p_start_date;                -- Current payment date

BEGIN
    -- Ensure the loan_schedule_temp table exists with the required structure and unique constraint
    CREATE TABLE IF NOT EXISTS wizeimmo.loan_schedule_temp (
        project_name VARCHAR,
        year_nb INT,
        year INT,
        month INT,
        monthly_payment DECIMAL,
        total_rest_to_pay DECIMAL,
        UNIQUE (project_name, year_nb, year, month)
    );

    -- Calculate the monthly payment amount using the formula for fixed-rate loans
    monthly_payment := total_amount * monthly_rate / (1 - POWER(1 + monthly_rate, -p_duration_months));

    -- Loop through each month to calculate the schedule
    WHILE i < p_duration_months LOOP
        -- Insert or update row in the loan schedule table using ON CONFLICT
        INSERT INTO wizeimmo.loan_schedule_temp (
            project_name,
            year_nb,
            year,
            month,
            monthly_payment,
            total_rest_to_pay
        ) VALUES (
            p_project_name,
            (i / 12) + 1,
            EXTRACT(YEAR FROM payment_date),
            EXTRACT(MONTH FROM payment_date),
            monthly_payment,
            remaining_balance
        )
        ON CONFLICT (project_name, year_nb, year, month)
        DO UPDATE SET
            monthly_payment = EXCLUDED.monthly_payment,
            total_rest_to_pay = EXCLUDED.total_rest_to_pay;

        -- Calculate remaining balance after this payment
        remaining_balance := remaining_balance - (monthly_payment - remaining_balance * monthly_rate);

        -- Move to the next month
        payment_date := payment_date + INTERVAL '1 month';
        i := i + 1;
    END LOOP;

    -- Set total_amount to the final remaining balance if needed as an output value
    total_amount := remaining_balance;
END;
$$;


truncate table wizeimmo.loan_schedule_temp;
CALL generate_loan_schedule(
    'VELPEAU', -- project name
    '2025-01-01', -- start date
    240,             -- 5 years (60 months)
    3   , --rate
    (155000*1.08)- (155000*1.08)*0.10 -- price loaned
);


CALL generate_loan_schedule(
    'PREBENDE', -- project name
    '2025-01-01', -- start date
    240,             -- 5 years (60 months)
    3   , --rate
    (150000*1.08)- (150000*1.08)*0.10-- price loaned
);


CALL generate_loan_schedule(
    'MIRABAU', -- project name
    '2025-01-01', -- start date
    240,             -- 5 years (60 months)
    3   , --rate
    (155000*1.08)- (155000*1.08)*0.10 -- price loaned
);


CREATE OR REPLACE PROCEDURE generate_all_loan_schedules()
LANGUAGE plpgsql
AS $$
DECLARE
    project_row RECORD;                     -- Declare a record variable for the loop
    project_name VARCHAR;                   -- Declare a variable to hold the project name
    start_date DATE := '2025-01-01';       -- Set the loan start date
    duration INT := 240;                    -- Duration in months (20 years)
    rate DECIMAL := 3;                      -- Annual interest rate
    total_project_cost DECIMAL;             -- Variable for total project cost
    loan_amount DECIMAL;                    -- Variable for calculated loan amount

BEGIN
    -- Clear existing loan schedule data
    TRUNCATE TABLE wizeimmo.loan_schedule_temp;

    -- Loop through each project in wizeimmo.sarl_properties
    FOR project_row IN
        SELECT property_name FROM wizeimmo.sarl_properties
    LOOP
        -- Retrieve project name from the record
        project_name := project_row.property_name;

        -- Retrieve and calculate the total project cost
        SELECT (purchase_price + notarial_fees + house_work_amount)
        INTO total_project_cost
        FROM wizeimmo.sarl_properties
        WHERE property_name = project_name;

        -- Calculate the loan amount as 90% of the total project cost
        loan_amount := total_project_cost - (total_project_cost * 0.10);

        -- Call the generate_loan_schedule procedure with calculated values
        CALL generate_loan_schedule(
            project_name,
            start_date,
            duration,
            rate,
            loan_amount
        );
    END LOOP;
END;
$$;



call generate_all_loan_schedules();

select * from wizeimmo.loan_schedule_temp;







with datas as (select project_name, monthly_payment
               from (select *
                     from (select *
                           from wizeimmo.loan_schedule_temp
                           where project_name = 'MIRABAU'
                           limit 1)
                     UNION
                     select *
                     from (select *
                           from wizeimmo.loan_schedule_temp
                           where project_name = 'VELPEAU'
                           limit 1)
                     UNION
                     select *
                     from (select *
                           from wizeimmo.loan_schedule_temp
                           where project_name = 'PREBENDE'
                           limit 1)))
select * from datas
UNION
SELECT 'TOTAL', sum(monthly_payment) from datas
order by monthly_payment asc
;