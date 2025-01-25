select * from wizeimmo.loan_parameters;

select * from wizeimmo.project_results;

CALL wizeimmo.calculate_minimal_rent(
    'Affordable Housing',/*Unique Name of the project*/
    155000,/*Annonced price of the project */
    TRUE, /*Notarial fee included in annonced price */
    55 /*surface*/
    );
