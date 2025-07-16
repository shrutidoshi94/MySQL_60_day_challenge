# Temporary Tables

Temporary tables in MySQL are special tables that **exist only for the duration of a client session** or **until explicitly dropped.**

Useful for storing intermediate results you need to reference multiple times within a complex query, or across several related queries in the same session, without affecting the permanent database schema.

## Characteristics of Temporary Tables

* Session-Specific
* Automatic Drop when the client session ends
* Naming a temporary table with the same name as a regular (non-temporary) table allowed
* improve query performance by breaking down complex operations into smaller, manageable steps.
* `IF NOT EXISTS` for`CREATE TEMPORARY TABLE` is useful if your script might be run multiple times and you want to avoid errors if the table already exists in the current session.


## SQL Syntax Examples

### 1. Creating a Temporary Table with Defined Columns

```sql
CREATE TEMPORARY TABLE TempEmployees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100),
    salary DECIMAL(10, 2)
);

-- Insert data into the temporary table
INSERT INTO TempEmployees (employee_id, first_name, last_name, department, salary) VALUES
(1, 'Alice', 'Smith', 'HR', 60000.00),
(2, 'Bob', 'Johnson', 'Sales', 75000.00),
(3, 'Charlie', 'Brown', 'IT', 90000.00);

-- Query the temporary table
SELECT * FROM TempEmployees WHERE salary > 70000;
```

### 2. Creating a Temporary Table from an Existing Query (`SELECT ... INTO`)

```sql
-- Assume you have a 'products' table and an 'order_items' table
CREATE TEMPORARY TABLE TempOrderSummary AS
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity * o.price) AS total_revenue
FROM
    products p
JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY
    p.product_id, p.product_name
ORDER BY
    total_revenue DESC;

-- Now you can work with TempOrderSummary
SELECT * FROM TempOrderSummary WHERE total_revenue > 10000;
```

### 3. Creating a Temporary Table with `IF NOT EXISTS`

```sql
CREATE TEMPORARY TABLE IF NOT EXISTS TempCustomers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);
```

### 4. Dropping a Temporary Table

Although temporary tables are automatically dropped at the end of the session, it's good practice to drop them explicitly when you're finished using them, especially in long-running scripts or procedures, to free up resources.

```sql
DROP TEMPORARY TABLE TempEmployees;
DROP TEMPORARY TABLE IF EXISTS TempOrderSummary; -- Use IF EXISTS to prevent errors if it doesn't exist
```
