# Data Definition Language (DDL)
A subset of SQL commands used specifically for defining, managing, and modifying the structure (or schema) of a database.

# 1. CREATE TABLE
Create a new, initially empty table in the current database. The table will be owned by the user issuing the command. 
  
`CREATE TABLE employees`

## 1.1 Defining columns

```sql
CREATE TABLE employees 
(employee_id INT,
name VARCHAR(100),
department VARCHAR(50),
salary DECIMAL(10,2),
hire_date DATE);
```

| employee_id | name | department | salary | hire_date |
| ----------- | ---- | ---------- | ------ | --------- |
|             |      |            |        |           |								
|             |      |            |        |           |	 

## 1.2 Data types

### Numeric

| **Type**         | **Description**                   | **Example**      | **Used for**                     |
| ---------------- | --------------------------------- | ---------------- | -------------------------------- |
| INT / INTEGER    | Whole numbers                     | `INT(11)`        | Auto-incrementing primary keys   |
| TINYINT          | Very small integers (1 byte)      | `TINYINT(1)`     | Boolean flags (0/1)              |
| SMALLINT         | Small integers (2 bytes)          | `SMALLINT(5)`    | Status codes, small counters     |
| MEDIUMINT        | Medium integers (3 bytes)         | `MEDIUMINT(8)`   | Traffic counters, mid-range IDs  |
| BIGINT           | Very large integers (8 bytes)     | `BIGINT(20)`     | Global IDs, huge counters        |
| DECIMAL(m,d)     | Fixed-point number (precision)    | `DECIMAL(10,2)`  | Currency, precise financial data |
| FLOAT, DOUBLE    | Floating-point (approximate)      | `FLOAT`/`DOUBLE` | Scientific measurements, stats   |
| BIT              | Binary values (0/1)               | `BIT(1)`         | Boolean storage, bit-flags       |

### String (Character) Data Types

| Type         | Description                             | Example             | Used for                               |
| ------------ | --------------------------------------- | ------------------- | --------------------------------------- |
| `CHAR(n)`    | Fixed-length string                     | `CHAR(10)`          | ISO codes, fixed-width fields          |
| `VARCHAR(n)` | Variable-length string                  | `VARCHAR(255)`      | Names, emails, titles                   |
| `TINYTEXT`   | Very small text (≤255 bytes)            | `TINYTEXT`          | Short comments, tiny notes              |
| `TEXT`       | Small text (≤65 535 bytes)              | `TEXT`              | Blog posts, customer feedback           |
| `MEDIUMTEXT` | Medium text (≤16 777 215 bytes)         | `MEDIUMTEXT`        | Article bodies, documentation           |
| `LONGTEXT`   | Large text (≤4 294 967 295 bytes)       | `LONGTEXT`          | Logs, large JSON/XML dumps              |
| `BINARY(n)`  | Fixed-length binary data                | `BINARY(16)`        | UUIDs, hashes                           |
| `VARBINARY(n)`| Variable-length binary data             | `VARBINARY(255)`    | Images, encrypted blobs                 |
| `ENUM(...)`  | Enumerated set of values                | `ENUM('A','B','C')` | Status flags, category codes            |
| `SET(...)`   | Zero or more values from a list         | `SET('x','y','z')`  | Multi-select tags, feature flags        |

### Date and Time Data Types

| Type        | Description                             | Example              | Used for                                |
| ----------- | --------------------------------------- | -------------------- | ---------------------------------------- |
| `DATE`      | Calendar date (YYYY-MM-DD)              | `DATE`               | Birthdates, deadlines                    |
| `DATETIME`  | Date & time (YYYY-MM-DD hh:mm:ss)       | `DATETIME`           | Event timestamps, logging                |
| `TIMESTAMP` | UTC-based date & time                   | `TIMESTAMP`          | Row update tracking, replication         |
| `TIME`      | Time of day or duration (hh:mm:ss)      | `TIME`               | Durations, business hours                |
| `YEAR`      | Year only (2- or 4-digit)              | `YEAR(4)`            | Model years, fiscal year indicators      |

### Spatial and JSON Types

| Type             | Description                              | Example                       | Used for                               |
| ---------------- | ---------------------------------------- | ----------------------------- | --------------------------------------- |
| `POINT`          | Single coordinate (x,y)                  | `POINT(40.7 -74.0)`           | Geo-locations, store latitude/longitude |
| `LINESTRING`     | Sequence of points                       | `LINESTRING(…)`               | Roads, paths                            |
| `POLYGON`        | Closed shape with one ring               | `POLYGON((…))`                | Areas, boundaries                       |
| `GEOMETRY`       | Any geometry type                        | `GEOMETRY`                    | Mixed spatial data                      |
| `GEOMETRYCOLLECTION` | Collection of geometries             | `GEOMETRYCOLLECTION(…)`       | Complex spatial objects                 |
| `JSON`           | Nested JSON document                     | `JSON`                        | Config blobs, semi-structured records    |


## Example 1: E-commerce orders table

A real-world table that covers numeric, string, date/time, JSON, spatial, and boolean types:

```sql
CREATE TABLE orders (
  order_id        BIGINT AUTO_INCREMENT PRIMARY KEY,  -- very large integer for unique order IDs
  user_id         INT NOT NULL,                       -- FK to users table
  status          ENUM('pending','paid','shipped','canceled') NOT NULL,
  total_amount    DECIMAL(10,2) NOT NULL,              -- currency
  placed_at       DATETIME     NOT NULL,              -- when the order was placed
  shipped_at      DATETIME     NULL,                  -- when it shipped (if ever)
  shipping_addr   JSON         NOT NULL,              -- {"street":…,"city":…,"zip":…}
  billing_addr    JSON         NOT NULL,
  is_gift         BIT(1)       NOT NULL DEFAULT 0,    -- boolean flag
  notes           TEXT         NULL,                  -- freeform notes
  pickup_point    POINT        NULL                   -- optional store pickup location
);
```


## Example 2: Social media posts feed

A second real-world schema covering char/varchar, JSON arrays, date, time, timestamp, set, floats, and spatial paths:

```sql
CREATE TABLE posts (
  post_id        BIGINT PRIMARY KEY,
  author_id      INT             NOT NULL,
  content        VARCHAR(1000)   NOT NULL,              -- up to 1,000 chars of text
  media_urls     JSON            NULL,                  -- ["https://…", …]
  created_date   DATE            NOT NULL,              -- date only
  created_time   TIME            NOT NULL,              -- separate time-of-day
  last_updated   TIMESTAMP       DEFAULT CURRENT_TIMESTAMP 
                                  ON UPDATE CURRENT_TIMESTAMP,
  visibility     SET('public','friends','private') 
                                  NOT NULL DEFAULT 'public',
  likes_count    MEDIUMINT       NOT NULL DEFAULT 0,    -- mid-range integer
  rating         FLOAT           NULL,                  -- approximate score/reactions
  tags           JSON            NULL,                  -- {"hashtags":[…],"mentions":[…]}
  route_of_post  LINESTRING      NULL                   -- path if user geotagged a walk
);
```

## 1.3 Constraints
Used to specify rules for the data in a table and limit the type of data that can go into a table. 
Constraints can be column level or table level. Column level constraints apply to a column, and table level constraints apply to the whole table.

| **Constraint**  | **Definition**                                                                    | **In-line (Column-level)** | **Table-level**          | **Allowed In**    |
| --------------- | --------------------------------------------------------------------------------- | -------------------------- | ------------------------ | ----------------- |
| **NOT NULL**    | Ensures a column **cannot contain NULL** values                                   | ✅ Yes                      | ❌ No                     | Only column-level |
| **DEFAULT**     | Sets a **default value** for a column when no value is provided                   | ✅ Yes                      | ❌ No                     | Only column-level |
| **UNIQUE**      | Ensures all values in a column or group of columns are **unique**                 | ✅ Yes                      | ✅ Yes                    | Both              |
| **PRIMARY KEY** | Uniquely identifies each row in the table; **NOT NULL + UNIQUE** combo            | ✅ Yes                      | ✅ Yes                    | Both              |
| **FOREIGN KEY** | Ensures values match values in another table’s column (**referential integrity**) | ✅ Yes                      | ✅ Yes                    | Both              |
| **CHECK**       | Validates values using a **Boolean condition**                                    | ✅ Yes                      | ✅ Yes                    | Both              |
| **INDEX**       | Speeds up lookups and joins; **not a constraint**, but a performance feature      | ❌ No                       | ✅ Yes (via CREATE INDEX) |                   |

Constraints can be defined in **two main ways**:

1. **Inline** (within column definitions)
2. **Out-of-line** or **table-level** (separate after columns, often using CONSTRAINT keyword)

### NOT NULL & DEFAULT
```sql
CREATE TABLE employees 
(
  id INT AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  status VARCHAR(20) DEFAULT 'active'
);
```

### UNIQUE
```sql
CREATE TABLE users 
(
  id INT,
  email VARCHAR(255) UNIQUE
);
```

```sql
CREATE TABLE users 
(
  id INT,
  email VARCHAR(255) 
  CONSTRAINT unique_email UNIQUE (email)
);
```

### PRIMARY KEY
Uniquely identifies each row in a table.
- Combines NOT NULL + UNIQUE
- Can be single or composite key (multiple columns)

```sql
CREATE TABLE customers 
(
  customer_id INT PRIMARY KEY,
  name VARCHAR(100)
);
```

```sql
CREATE TABLE customers 
(
  customer_id INT,
  name VARCHAR(100)
  CONSTRAINT pk_id PRIMARY KEY (id)
);
```
### COMPOSITE KEY

```sql
CREATE TABLE orders 
(
  order_id INT,
  product_id INT,
  PRIMARY KEY (order_id, product_id)
);
```

```sql
CREATE TABLE orders 
(
  order_id INT,
  product_id INT,
  CONSTRAINT pk_composite PRIMARY KEY (order_id, product_id)
);
```

### FOREIGN KEY
Links one table to another (establishes relationships).

```sql
CREATE TABLE Orders 
(
  order_id INT PRIMARY KEY,
  customer_id INT REFERENCES Customers(id)
);
```

```sql
CREATE TABLE departments 
(
  department_id INT PRIMARY KEY,
  department_name VARCHAR(50)
);

CREATE TABLE employees 
(
  employee_id INT PRIMARY KEY,
  name VARCHAR(100),
  department_id INT,
  CONSTRAINT fk_dept FOREIGN KEY (department_id)
  REFERENCES departments(department_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
```

```sql
--shorthand 
FOREIGN KEY (department_id) REFERENCES departments(department_id)
```

**ON DELETE CASCADE**

- This defines the **action to take if a referenced record is deleted** in the parent table.
- If a department is deleted from departments, all employees with that department_id in the current table will also be **automatically deleted**.

**ON UPDATE CASCADE**

- This defines the **action to take if the referenced department_id is updated** in the parent table.
- If a department’s department_id is changed, it will **automatically update** the corresponding department_id in this table.


### CHECK
Ensures column values meet a specific condition.

```sql
CREATE TABLE products 
(
  id INT,
  price DECIMAL(10,2),
  CHECK (price > 0)
);
```

```sql
CREATE TABLE products (
  id INT,
  price DECIMAL(10,2),
  CONSTRAINT chk_age CHECK (age >= 18)
  );
```

### AUTO_INCREMENT
Automatically increases numeric values, usually for primary keys.

```sql
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  order_date DATE
);
```

## 1.4 Indexing
An index is a performance tool that speeds up data retrieval.

**Index Key Facts:**

- Used to **speed up** SELECT, JOIN, WHERE, ORDER BY, etc.
- Think of it as a “lookup table” or an index in a book.
- Does **not enforce data rules** (unless part of a constraint like UNIQUE).

| **Feature** | **Constraint?** | **Index Created?** | **Purpose**                           |
| ----------- | --------------- | ------------------ | ------------------------------------- |
| PRIMARY KEY | ✅ Yes           | ✅ Automatically    | Enforces uniqueness + fast lookup     |
| UNIQUE      | ✅ Yes           | ✅ Automatically    | Enforces no duplicates + fast lookup  |
| FOREIGN KEY | ✅ Yes           | ❌ (usually)        | Enforces relationship, no index added |
| INDEX       | ❌ No            | ✅ Yes              | For performance only, not validation  |

So:
- A **constraint may create an index**, but
- An **index is not itself a constraint**.

Without an index, MySQL must scan every row (called a full table scan).
With an index, MySQL uses a tree-like data structure (usually **B-tree**) to jump directly to relevant rows — much faster.

Types of Indexes in MySQL:
| **Type**        | **Description**                                              |
| --------------- | ------------------------------------------------------------ |
| **PRIMARY**     | Automatically created on PRIMARY KEY columns                 |
| **UNIQUE**      | Prevents duplicate values; creates an index                  |
| **INDEX / KEY** | Basic non-unique index                                       |
| **FULLTEXT**    | For searching large text columns (MATCH ... AGAINST)         |
| **SPATIAL**     | For spatial (geometric) data types like POINT, POLYGON, etc. |

### Basic Index
```sql
CREATE INDEX index_name
ON table_name (column_name);
```

### Unique Index
```sql
CREATE UNIQUE INDEX idx_email 
ON users(email);
```

### Composite Index
```sql
CREATE INDEX idx_dept_age 
ON employees(department, age);
```

### FullText Index
```sql
CREATE FULLTEXT INDEX idx_bio 
ON users(bio);

SELECT * 
FROM users
WHERE 
	MATCH(bio) AGAINST('developer engineer' IN NATURAL LANGUAGE MODE);
```

### Inline
```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    INDEX idx_dept (department)
);
```

**Downsides of Indexes**
| **Disadvantage**             | **Explanation**                             |
| ---------------------------- | ------------------------------------------- |
| Extra Storage                | Indexes use disk space                      |
| Slower INSERT/UPDATE/DELETE  | MySQL must update indexes when data changes |
| Too Many Indexes = Confusion | More isn’t always better — adds overhead    |

# 2. ALTER TABLE
Used to modify the structure of an existing table. It allows you to add, remove, or change columns, modify data types, or add/drop constraints without losing data. 
```sql
ALTER TABLE table_name
<modification_action>;
```

### 2.1 Add Operations

| **Operation**                     | **Syntax**          | **Example**                                                                                              |
| --------------------------------- | ------------------- | -------------------------------------------------------------------------------------------------------- |
| **Add a column**                  | ADD COLUMN          | ALTER TABLE employees<br>ADD COLUMN dob DATE;<br>                                                        |
| **Add multiple columns**          | ADD COLUMN (repeat) | ALTER TABLE employees<br>ADD COLUMN dob DATE,<br>ADD COLUMN gender CHAR(1);<br>                          |
| **Add a constraint**              | ADD CONSTRAINT      | ALTER TABLE orders<br>ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(id);<br> |
| **Add an index**                  | ADD INDEX           | ALTER TABLE users<br>ADD INDEX idx_email (email);<br>                                                    |
| **Add a unique constraint/index** | ADD UNIQUE          | ALTER TABLE users<br>ADD UNIQUE (username);<br>                                                          |
| **Add primary key**               | ADD PRIMARY KEY     | ALTER TABLE students<br>ADD PRIMARY KEY (student_id);<br>                                                |
| **Add foreign key**               | ADD FOREIGN KEY     | ALTER TABLE orders<br>ADD FOREIGN KEY (product_id) REFERENCES products(id);<br>                          |
| **Add check constraint**          | ADD CHECK           | ALTER TABLE employees<br>ADD CHECK (salary > 0);<br>                                                     |
| **Add fulltext index**            | ADD FULLTEXT        | ALTER TABLE posts<br>ADD FULLTEXT (title);<br>                                                           |
| **Add spatial index**             | ADD SPATIAL         | ALTER TABLE locations<br>ADD SPATIAL (coordinates);<br>                                                  |


### 2.2 Modify Column Definitions


| **Operation**          | **Syntax**                         | **Example**                                                             |
| ---------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| **Change data type**   | MODIFY COLUMN                      | ALTER TABLE employees<br>MODIFY COLUMN salary DECIMAL(12, 2);<br>       |
| **Change name & type** | CHANGE COLUMN                      | ALTER TABLE employees<br>CHANGE COLUMN name full_name VARCHAR(100);<br> |
| **Set/Remove DEFAULT** | ALTER COLUMN ... SET/ DROP DEFAULT | ALTER TABLE users<br>ALTER COLUMN status SET DEFAULT 'active';<br>      |
| **Set NOT NULL**       | MODIFY                             | ALTER TABLE users<br>MODIFY COLUMN email VARCHAR(100) NOT NULL;<br>     |


### 2.3 Drop Operations

| **Operation**                   | **Syntax**              | **Example**                                             |
| ------------------------------- | ----------------------- | ------------------------------------------------------- |
| **Drop a column**               | DROP COLUMN             | ALTER TABLE employees<br>DROP COLUMN dob;<br>           |
| **Drop a constraint (by name)** | DROP CONSTRAINT         | ALTER TABLE orders<br>DROP FOREIGN KEY fk_customer;<br> |
| **Drop primary key**            | DROP PRIMARY KEY        | ALTER TABLE employees<br>DROP PRIMARY KEY;<br>          |
| **Drop unique index**           | DROP INDEX              | ALTER TABLE users<br>DROP INDEX idx_email;<br>          |
| **Drop check constraint**       | DROP CHECK (MySQL 8.0+) | ALTER TABLE employees<br>DROP CHECK chk_salary;<br>     |
| **Drop foreign key**            | DROP FOREIGN KEY        | ALTER TABLE orders<br>DROP FOREIGN KEY fk_product;<br>  |

 
 **Only one PRIMARY KEY allowed per table** — so this removes the unique identifier for rows.
 
 **You can’t drop it if it’s tied to an AUTO_INCREMENT column**, unless you modify that column first.

 **If other tables reference it as a FOREIGN KEY**, you must first drop or update those constraints.

```sql
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100)
);

ALTER TABLE products
DROP PRIMARY KEY;  -- ❌ ERROR!

ALTER TABLE products
MODIFY COLUMN id INT;       -- Remove AUTO_INCREMENT
ALTER TABLE products
DROP PRIMARY KEY;           -- Now allowed
```

### 2.4 Rename Operations

| **Operation**     | **Syntax**    | **Example**                                                                |
| ----------------- | ------------- | -------------------------------------------------------------------------- |
| **Rename table**  | RENAME TO     | ALTER TABLE old_table<br>RENAME TO new_table;<br>                          |
| **Rename column** | CHANGE COLUMN | ALTER TABLE employees<br>CHANGE COLUMN old_name new_name VARCHAR(100);<br> |

### 2.5 Reorder or Position Columns

| **Operation**                     | **Syntax**                  | **Example**                                                    |
| --------------------------------- | --------------------------- | -------------------------------------------------------------- |
| **Reorder a column**              | ADD/MODIFY ... AFTER column | ALTER TABLE employees<br>MODIFY COLUMN age INT AFTER name;<br> |
| **Move column to first position** | ... FIRST                   | ALTER TABLE employees<br>MODIFY COLUMN id INT FIRST;<br>       |

### 2.6 Partitioning (Advanced Use)
Dividing a table into smaller, manageable chunks called partitions. This is a technique for improving performance and managing large tables by splitting data based on specific criteria, like date, time, or numerical ranges. 
| **Operation**           | **Syntax**          | **Example**                                                   |
| ----------------------- | ------------------- | ------------------------------------------------------------- |
| **Add partition**       | PARTITION BY        | ALTER TABLE sales<br>PARTITION BY RANGE(YEAR(sale_date));<br> |
| **Remove partitioning** | REMOVE PARTITIONING | ALTER TABLE sales<br>REMOVE PARTITIONING;<br>                 |

### 2.7 Other Advanced Options
| **Operation**                    | **Syntax**       | **Example**                                                                                      |
| -------------------------------- | ---------------- | ------------------------------------------------------------------------------------------------ |
| **Add comment to column**        | MODIFY or CHANGE | ALTER TABLE employees MODIFY COLUMN salary DECIMAL(10,2) COMMENT 'Annual salary';                |
| **Add virtual/generated column** | ADD COLUMN       | ALTER TABLE orders ADD COLUMN total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity \* price); |


## 3. Truncate

**Truncate**
- Remove all rows from a table, retain structure
- Quickly deletes **all records** from a table **without logging each row deletion**.
- Resets **AUTO_INCREMENT** values.

```sql
TRUNCATE TABLE employees;
```

**Drop**
- Delete an object (table, view, database, etc.)
- Deletes data + definition.
- **Irreversible** — all data is lost.
- Foreign key constraints must be considered.

  ```sql
DROP TABLE table_name;
DROP DATABASE database_name;
DROP VIEW view_name;
```

## DELETE vs TRUNCATE vs DROP
| Feature                  | `DELETE`                  | `TRUNCATE`                            | `DROP`                          |
| ------------------------ | ------------------------- | ------------------------------------- | ------------------------------- |
| **What it does**         | Removes **rows**          | Removes **all rows**, resets identity | Deletes **entire table**        |
| **WHERE allowed**        | ✅ Yes                     | ❌ No                                  | ❌ No                            |
| **Rollback**             | ✅ Yes (if in transaction) | ⚠️ No (depends on engine)             | ❌ No                            |
| **Speed**                | 🐢 Slower (row-by-row)    | ⚡ Fast (deallocates pages)            | ⚡⚡ Fastest (removes everything) |
| **Triggers fire**        | ✅ Yes                     | ❌ No                                  | ❌ No                            |
| **Auto Increment reset** | ❌ No                      | ✅ Yes                                 | ✅ Yes (if recreated)            |
| **Table remains**        | ✅ Yes                     | ✅ Yes                                 | ❌ No                            |
| **Schema retention**     | ✅ Yes (structure remains) | ✅ Yes (structure remains)             | ❌ No (structure deleted)        |


## 4. Rename
- Changes the name of an existing table (or database in older versions).
- Can’t rename to an existing table name.
- Cannot rename a table across databases.

```sql
RENAME TABLE old_name TO new_name;
```

```sql
RENAME TABLE a TO b, c TO d; --Rename multiple tables
```

**❌ You Cannot Rename Columns with RENAME**
Instead, use ALTER TABLE ... CHANGE or ALTER TABLE ... RENAME COLUMN.

**❌ You Cannot Rename Databases with RENAME DATABASE**
Manually create and migrate: Create new database, Export and import data, Drop old database.

## 5. Comment
- Add a comment to a table or column
- Documents metadata for future reference (via SHOW CREATE TABLE).

```sql
CREATE TABLE employees (
  id INT,
  name VARCHAR(100) COMMENT 'Full name of employee'
) COMMENT = 'Employee master data table';
```

**Add or update comment using ALTER:**
```sql
ALTER TABLE employees
MODIFY name VARCHAR(100) COMMENT 'Updated full name description';

ALTER TABLE employees
COMMENT = 'Stores company employee info';
```

**View Comments**
```sql
SHOW CREATE TABLE employees;
```
