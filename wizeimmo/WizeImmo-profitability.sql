CREATE TABLE IF NOT EXISTS wizeimmo.project_results (
    id SERIAL PRIMARY KEY,
    project_name VARCHAR UNIQUE,            -- Ensure this column is unique for upsert
    project_date TIMESTAMP,
    project_price INT,                      -- Initial project price input
    project_price_with_fees INT,            -- Adjusted price if notarial fees are included
    cost_of_loan DECIMAL,                   -- Total loan amount after down payment
    loan_rate DECIMAL(5, 2),                -- Loan interest rate
    loan_duration_years INT,                -- Loan term in years
    notarial_fee_percentage DECIMAL(5, 2), -- Notarial fee percentage from parameters
    notarial_fee_amount DECIMAL,           -- Calculated notarial fees in value
    vacancy_rate DECIMAL(5, 2),            -- Vacancy rate from parameters
    down_payment_percentage DECIMAL(5, 2), -- Down payment percentage from parameters
    down_payment_amount DECIMAL,           -- Calculated down payment in value
    minimal_rent_to_roi DECIMAL,           -- Calculated minimal rent to be ROI positive
    minimal_rent_per_sqm DECIMAL           -- Minimal rent per square meter
);

select * from wizeimmo.project_results;

CREATE TABLE IF NOT EXISTS wizeimmo.loan_parameters (
    id SERIAL PRIMARY KEY,
    loan_rate DECIMAL(5, 2) NOT NULL,                -- Annual loan interest rate (%)
    loan_duration_years INT NOT NULL,               -- Loan term in years
    notarial_fee_percentage DECIMAL(5, 2) NOT NULL, -- Notarial fee percentage (%)
    vacancy_rate DECIMAL(5, 2) NOT NULL,            -- Vacancy rate (%)
    down_payment_percentage DECIMAL(5, 2) NOT NULL  -- Down payment percentage (%)
);

TRUNCATE TABLE wizeimmo.loan_parameters;

INSERT INTO wizeimmo.loan_parameters (
    loan_rate, 
    loan_duration_years, 
    notarial_fee_percentage, 
    vacancy_rate, 
    down_payment_percentage
) VALUES (
    3.0,   -- Loan rate: 3%
    20,    -- Loan duration: 20 years
    7.5,   -- Notarial fee: 7.5%
    3.0,   -- Vacancy rate: 3%
    20.0   -- Down payment: 20%
);
select * from wizeimmo.loan_parameters;

CREATE OR REPLACE PROCEDURE wizeimmo.calculate_minimal_rent(
    p_project_name VARCHAR,
    p_price INT,
    p_notarial_fees_included BOOLEAN,
    p_surface FLOAT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_loan_rate DECIMAL(5, 2);
    v_loan_duration_years INT;
    v_notarial_fee_percentage DECIMAL(5, 2);
    v_vacancy_rate DECIMAL(5, 2);
    v_down_payment_percentage DECIMAL(5, 2);
    down_payment DECIMAL;
    notarial_fee_amount DECIMAL;
    loan_amount DECIMAL;
    monthly_interest_rate DECIMAL;
    total_months INT;
    monthly_payment DECIMAL;
    monthly_maintenance_cost DECIMAL;
    total_monthly_cost DECIMAL;
    required_rent DECIMAL;
    adjusted_price INT;
    rent_per_sqm DECIMAL;
BEGIN
    -- Fetch parameters from the loan_parameters table
    SELECT lp.loan_rate, lp.loan_duration_years, lp.notarial_fee_percentage, lp.vacancy_rate, lp.down_payment_percentage
    INTO v_loan_rate, v_loan_duration_years, v_notarial_fee_percentage, v_vacancy_rate, v_down_payment_percentage
    FROM wizeimmo.loan_parameters lp
    LIMIT 1;

    -- Adjust the project price if notarial fees are not included
    IF NOT p_notarial_fees_included THEN
        notarial_fee_amount := p_price * (v_notarial_fee_percentage / 100);
        adjusted_price := p_price + notarial_fee_amount;
    ELSE
        adjusted_price := p_price;
        notarial_fee_amount := 0;
    END IF;

    -- Calculate the down payment
    down_payment := adjusted_price * (v_down_payment_percentage / 100);

    -- Calculate the loan amount after down payment
    loan_amount := adjusted_price - down_payment;

    -- Monthly interest rate
    monthly_interest_rate := v_loan_rate / 100 / 12;
    
    -- Total number of months
    total_months := v_loan_duration_years * 12;

    -- Calculate the monthly loan payment using the mortgage formula
    monthly_payment := loan_amount * (monthly_interest_rate * POWER(1 + monthly_interest_rate, total_months)) /
                       (POWER(1 + monthly_interest_rate, total_months) - 1);

    -- Estimate monthly maintenance cost (e.g., 1% of adjusted price annually)
    monthly_maintenance_cost := (adjusted_price * 0.01) / 12;

    -- Total monthly cost
    total_monthly_cost := monthly_payment + monthly_maintenance_cost;

    -- Calculate the required rent to cover all costs, considering the vacancy rate
    required_rent := total_monthly_cost / (1 - v_vacancy_rate / 100);

    -- Calculate rent per square meter
    rent_per_sqm := required_rent / p_surface;

    -- Upsert the results into the project_results table
    INSERT INTO wizeimmo.project_results (
        project_name,
        project_date,
        project_price,
        project_price_with_fees,
        cost_of_loan,
        loan_rate,
        loan_duration_years,
        notarial_fee_percentage,
        notarial_fee_amount,
        vacancy_rate,
        down_payment_percentage,
        down_payment_amount,
        minimal_rent_to_roi,
        minimal_rent_per_sqm
    ) VALUES (
        p_project_name,
        NOW(),
        p_price,
        adjusted_price,
        loan_amount,
        v_loan_rate,
        v_loan_duration_years,
        v_notarial_fee_percentage,
        notarial_fee_amount,
        v_vacancy_rate,
        v_down_payment_percentage,
        down_payment,
        required_rent,
        rent_per_sqm
    )
    ON CONFLICT (project_name) DO UPDATE SET
        project_date = NOW(),
        project_price = EXCLUDED.project_price,
        project_price_with_fees = EXCLUDED.project_price_with_fees,
        cost_of_loan = EXCLUDED.cost_of_loan,
        loan_rate = EXCLUDED.loan_rate,
        loan_duration_years = EXCLUDED.loan_duration_years,
        notarial_fee_percentage = EXCLUDED.notarial_fee_percentage,
        notarial_fee_amount = EXCLUDED.notarial_fee_amount,
        vacancy_rate = EXCLUDED.vacancy_rate,
        down_payment_percentage = EXCLUDED.down_payment_percentage,
        down_payment_amount = EXCLUDED.down_payment_amount,
        minimal_rent_to_roi = EXCLUDED.minimal_rent_to_roi,
        minimal_rent_per_sqm = EXCLUDED.minimal_rent_per_sqm;
END;
$$;


 CALL wizeimmo.calculate_minimal_rent('Affordable Housing', 155000, TRUE, 55);

select * from wizeimmo.project_results;