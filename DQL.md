# Data Query Language (DQL) - SELECT 
A subset of SQL commands used specifically to retrieve data from one or more tables, producing a result set. 

## 1.	SELECT list & Aliasing
Comma-separated sequence of one or more expressions you place immediately after the SELECT keyword. 

**What you can put in the `SELECT` list**
- Simple column references. e.g. `user_id`, `created_at`
- Wildcard. e.g. `*` or `t.*`
- Literals. e.g. `42`, `'hello'`
- Arithmetic & other expressions. e.g. `price * quantity`, `IF(status='A','Active','Inactive')`
- Function calls  
  - Scalar functions: `CONCAT(first_name, ' ', last_name)`  
  - Aggregate functions: `SUM(amount)`, `COUNT(*)`  
  - Window functions: `ROW_NUMBER() OVER (…)`, `AVG(salary) OVER (…)`  
- Subqueries (scalar subqueries returning at most one value)
- Any combination of the above, with optional aliasing
  
```sql
SELECT
  e.id,
  CONCAT(e.first_name, ' ', e.last_name) AS full_name,
  e.salary * 1.10                    AS increased_salary,
  ROW_NUMBER() OVER (
    PARTITION BY e.department_id
    ORDER BY e.hire_date
  )                                   AS hire_seq_in_dept,
  (SELECT MAX(salary)
     FROM employees
    WHERE department_id = e.department_id
  )                                   AS max_dept_salary,
  '2025-06-09'                        AS report_date
FROM employees AS e
WHERE e.active = 1
ORDER BY increased_salary DESC
LIMIT 10;
```

### 1.1 Wildcard *
Used to select all columns
`SELECT *`

### 1.2 Alais AS

**Column Aliases**
```sql
SELECT 
	first_name AS name 
FROM employees;
```
```sql
SELECT 
	first_name name 
FROM employees;
```
**Table Aliases**
```sql
SELECT 
	e.first_name, 
	e.salary
FROM employees AS e;
```

**Alias in Subqueries / Derived Tables**

```sql
SELECT 
	dept, 
	avg_salary
FROM 
	(SELECT 
		department AS dept, 
		AVG(salary) AS avg_salary
	FROM employees
	GROUP BY department) AS dept_summary;
```

## 2.	FROM 
FROM table_references [PARTITION (part_list)]  ￼
 
## 3. JOINS

## 4.	WHERE - Filtering

**% - Matches Zero or More Characters**
```sql
--- Names that contain 'oh'
SELECT * 
FROM employees
WHERE first_name LIKE '%oh%';
```

**_ - Matches Exactly One Character**
```sql
--- Names with exactly 5 characters
SELECT * 
FROM employees
WHERE first_name LIKE '_____';  -- 5 underscores
```


**Escape Wildcards When Needed**
If your search includes actual % or _ characters (e.g., emails), use ESCAPE:
```sql
--- Find emails containing a literal '%'
SELECT * 
FROM logs
WHERE message LIKE '%!%%' ESCAPE '!';
```


## 5.	Grouping & aggregation
	•	GROUP BY col_name|expr|pos [, …] [WITH ROLLUP]  ￼
	•	HAVING where_condition  ￼

## 6.	SELECT modifiers (must appear immediately after SELECT)  ￼
	•	ALL | DISTINCT | DISTINCTROW
	•	HIGH_PRIORITY
	•	STRAIGHT_JOIN
	•	SQL_SMALL_RESULT | SQL_BIG_RESULT | SQL_BUFFER_RESULT
	•	SQL_NO_CACHE | SQL_CALC_FOUND_ROWS
 
## 7.	Ordering
	•	ORDER BY col_name|expr|pos [ASC|DESC] [, …] [WITH ROLLUP]  ￼
 
## 8.	Limiting results
	•	LIMIT {[offset,] row_count | row_count OFFSET offset}  ￼
 ￼
## 9.	Windows Functions & Window definitions
	•	WINDOW window_name AS (window_spec) [, …] 

## 10.	Subqueries & derived tables
	•	Scalar, row, EXISTS, IN, ANY/ALL subqueries anywhere in select list, WHERE, HAVING, etc.
	•	(SELECT …) AS alias in FROM (derived/lateral tables)  

## 11.	Common Table Expressions
	•	WITH [RECURSIVE] cte_name [(col_list)] AS (subquery) [, …]  ￼

## 12.	Set operations (combine multiple SELECTs)
	•	UNION [ALL | DISTINCT]
	•	INTERSECT [ALL | DISTINCT]
	•	EXCEPT [ALL | DISTINCT] 

## 13.	INTO options (capture results)  ￼
	•	INTO OUTFILE 'file_name' …
	•	INTO DUMPFILE 'file_name'
	•	INTO var_name [, var_name …]

## 14.	Locking reads
	•	FOR UPDATE | FOR SHARE [OF tbl_list] [NOWAIT | SKIP LOCKED]
	•	LOCK IN SHARE MODE  
 
## 15.	Parenthesized query expressions
	•	You can wrap any SELECT (with its ORDER BY/LIMIT) in parentheses to treat it like a table or to apply further sorting/limiting. 
