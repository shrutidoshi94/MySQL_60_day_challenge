SELECT *
FROM employee_demographics;

INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(13, 'Parker', 'Pascal', NULL, 'M', '1990-05-15'); 



SELECT
    employee_id,
    first_name,
    ISNULL age AS not_alive
FROM employee_demographics;