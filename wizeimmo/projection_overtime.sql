CREATE TABLE wizeimmo.time_pivot_table (
    id SERIAL PRIMARY KEY,
    year_number INT,
    year INT
);

-- Insert years from 2024 to 2074
DO $$
DECLARE
    i INT := 0;
BEGIN
    FOR i IN 0..50 LOOP
        INSERT INTO wizeimmo.time_pivot_table (year_number, year)
        VALUES (i + 1, 2024 + i);
    END LOOP;
END $$;


-- projection
with datas as (select piv.*,
                      proj.project_name,
                      proj.project_price,
                      proj.cost_of_loan,
                      proj.down_payment_amount,
                      proj.minimal_rent_to_roi
               from wizeimmo.time_pivot_table as piv
                        left join wizeimmo.project_results as proj
                                  on 1 = 1
                                      AND proj.project_name =
                                          'Appartement 2 pièces 58 m² Velpeau avec Garage et travaux compris '
               where 1 = 1
                 AND year_number <= 30)
select
    src.project_name,
    src.project_price as project_total_price,
    src.cost_of_loan as loan_amount,
    par.loan_rate
from datas as src
inner join wizeimmo.loan_parameters as par
on 1=1;


-- Projection and Loan Repayment Calculation
WITH datas AS (
    SELECT
        piv.*,
        proj.project_name,
        proj.project_price,
        proj.cost_of_loan AS loan_amount,
        proj.down_payment_amount,
        proj.minimal_rent_to_roi,
        par.loan_rate AS annual_interest_rate
    FROM wizeimmo.time_pivot_table AS piv
    LEFT JOIN wizeimmo.project_results AS proj
        ON 1=1
        and proj.project_name = 'Appartement 2 pièces 58 m² Velpeau avec Garage et travaux compris '
    INNER JOIN wizeimmo.loan_parameters AS par
        ON 1 = 1
    WHERE year_number <= 30
)/*,
annual_repayments AS (*/
    -- Calculate the annual payment for both portions of the loan
    SELECT
        d.year,
        d.year_number,
        d.project_name,
        d.loan_amount * 0.6 AS long_term_principal,
        d.loan_amount * 0.4 AS short_term_principal,
        (d.loan_amount * 0.6) *
            ((d.annual_interest_rate * POWER(1 + d.annual_interest_rate, 20)) /
             (POWER(1 + d.annual_interest_rate, 20) - 1)) AS long_term_annual_payment,
        (d.loan_amount * 0.4) *
            ((d.annual_interest_rate * POWER(1 + d.annual_interest_rate, 10)) /
             (POWER(1 + d.annual_interest_rate, 10) - 1)) AS short_term_annual_payment
    FROM datas AS d;


WITH datas AS (
    SELECT
        piv.*,
        proj.project_name,
        proj.project_price,
        proj.cost_of_loan AS loan_amount,
        proj.down_payment_amount,
        proj.minimal_rent_to_roi,
        par.loan_rate AS annual_interest_rate
    FROM wizeimmo.time_pivot_table AS piv
    LEFT JOIN wizeimmo.project_results AS proj
        ON proj.project_name = 'Appartement 2 pièces 58 m² Velpeau avec Garage et travaux compris '
    INNER JOIN wizeimmo.loan_parameters AS par
        ON 1 = 1
    WHERE year_number <= 30
), full_proj_cost AS (
    -- Calculate total repayment for 60% over 20 years and 40% over 10 years
    SELECT
        d.project_name,
        d.year,
        d.year_number,
        d.loan_amount * 0.6 AS long_term_principal_60_percent,
        d.loan_amount * 0.4 AS short_term_principal_40_percent,
        0.03 AS interest_rate,     -- 3%
        20 AS period_60_percent, -- 20 years for 60%
        10 AS period_40_percent, -- 10 years for 40%
        -- Total repayment for 60% over 20 years
        (
            (d.loan_amount * 0.6) *
            (0.03 * POWER(1 + 0.03, 20)) /
            (POWER(1 + 0.03, 20) - 1)
        ) * 20 AS total_repayment_60_percent,
        (
            (d.loan_amount * 0.4) *
            (0.03 * POWER(1 + 0.03, 10)) /
            (POWER(1 + 0.03, 10) - 1)
        ) * 10 AS total_repayment_40_percent,
        (
            (d.loan_amount * 0.6) *
            (0.03 * POWER(1 + 0.03, 20)) /
            (POWER(1 + 0.03, 20) - 1)
        ) AS yearly_repayment_60_percent,
        (
            (d.loan_amount * 0.4) *
            (0.03 * POWER(1 + 0.03, 10)) /
            (POWER(1 + 0.03, 10) - 1)
        ) AS yearly_repayment_40_percent
    FROM datas AS d
)
SELECT
    proj.project_name,
    proj.year_number,
    proj.year,
    ROUND(proj.yearly_repayment_40_percent/12, 2) AS monthly_repayment_40_percent,
    ROUND(proj.yearly_repayment_60_percent/12, 2) AS monthly_repayment_60_percent,
    ROUND(proj.yearly_repayment_40_percent/12, 2) + ROUND(proj.yearly_repayment_60_percent/12, 2) as  monthly_repayment_100_percent,
    ROUND(proj.total_repayment_40_percent, 2) AS total_repayment_40_percent,
    ROUND(proj.total_repayment_60_percent, 2) AS total_repayment_60_percent,
    ROUND(proj.yearly_repayment_40_percent, 2) AS yearly_repayment_40_percent,
    ROUND(proj.yearly_repayment_60_percent, 2) AS yearly_repayment_60_percent,

    -- Calculate remaining amount to repay for 40% and 60%
    ROUND(
        proj.total_repayment_40_percent
        - (proj.yearly_repayment_40_percent * LEAST(proj.year_number, 10)),
        2
    ) AS remaining_amount_to_repay_40_percent,

    ROUND(
        proj.total_repayment_60_percent
        - (proj.yearly_repayment_60_percent * LEAST(proj.year_number, 20)),
        2
    ) AS remaining_amount_to_repay_60_percent,
    850 as estimated_rent,
    0.6*850*12 as rent_60_percent_estimated_yearly,
    0.4*850*12 as rent_40_percent_estimated_yearly,
    850*0.6 as monthly_rent60_percent,
    850*0.4 as monthly_rent40_percent,
    ROUND(proj.yearly_repayment_60_percent, 2)/12 as monthly_repayment_60_percent,
    ROUND(proj.yearly_repayment_40_percent, 2)/12 as monthly_repayment_40_percent,
    850*0.6 - ROUND(proj.yearly_repayment_60_percent, 2)/12 as monthly_60_percent_cashflow,
    850*0.4 - ROUND(proj.yearly_repayment_40_percent, 2)/12 as monthly_40_percent_cashflow,
    0.6*850*12 - ROUND(proj.yearly_repayment_60_percent, 2)   as cashflow_yearly_60_percent,
    0.4*850*12 - ROUND(proj.yearly_repayment_40_percent, 2)    as cashflow_yearly_40_percent,
    case
        when proj.year_number <=20 THEN (0.6*850*12 - ROUND(proj.yearly_repayment_60_percent, 0)  ) * proj.year_number
        ELSE (0.6*850*12)*(proj.year_number-20)
    end as cashflow_year_X_60_percent,
    case
        when proj.year_number <=10 THEN ( 0.4*850*12 - ROUND(proj.yearly_repayment_40_percent, 0)  ) * proj.year_number
        ELSE (0.4*850*12)*(proj.year_number-10)
    end as cashflow_year_X_40_percent
FROM full_proj_cost AS proj;
