# Views

A **view** is a virtual table in SQL that:

- Is based on the **result of a query**
- Does **not store data** physically
- Acts as a **stored SELECT statement**

### Views vs Tables


| Feature       | Tables             | Views                                                                        |
| --------------- | -------------------- | ------------------------------------------------------------------------------ |
| Stores Data   | ✅ Yes             | ❌ No                                                                        |
| Speed         | ⚡ Faster          | 🐢 Slower (due to underlying query)                                          |
| Writable      | ✅ Yes             | ⚠️ Mostly Read-Only (Some views may be updatable if they meet MySQL rules) |
| Maintained By | Developers/DBAs    | Developers                                                                   |
| Use Case      | Persistent storage | Abstraction, reuse, security                                                 |

**Where Are Views Defined?**

- Inside a **schema** in a **database**
- Managed using **DDL** commands like `CREATE`, `ALTER`, `DROP`
- Views belong to the **logical layer** of the database

## Three-Level Database Architecture


| Layer           | Description                                                          | Who Uses It          |
| ----------------- | ---------------------------------------------------------------------- | ---------------------- |
| Physical        | Data files, logs, caches – actual storage                           | DBAs                 |
| Logical         | Tables, views, indexes, relationships                                | Developers/Engineers |
| View (External) | High-level views for apps, analysts, tools – customized, simplified | Analysts/Apps        |

## Why Use Views?

### Use Case 1: **Reusable Logic Across Queries**

- Abstract complex joins, aggregations, and logic
- Avoid repeating the same subquery or CTE
- Great for **shared logic** used by many users

### Use Case 2: **Hide Complexity**

- Present simplified, user-friendly datasets
- No need for end users to understand joins or schemas

### Use Case 3: **Security Layer**

- Implement **column-level** or **row-level** security
- Create role-specific views (e.g., EU sales team)

### Use Case 4: **Maintain Stability During Table Changes**

- Rename/split columns in tables without breaking users' queries
- Use views as **stable public interfaces**

### Use Case 5: **Multi-language Support**

- Offer localized column and view names in German, Hindi, etc.

### Use Case 6: **Virtual Data Marts in Data Warehouses**

- Use views as **virtual data marts** grouped by topic or department
- Keep warehouse logic centralized, avoid duplicating ETL layers

## Syntax

```sql
-- Creating Views
CREATE [OR REPLACE] VIEW schema_name.view_name AS (
  SELECT column1, column2
  FROM table_name
  WHERE condition
);

-- Example: Monthly Sales Summary View
CREATE VIEW sales.v_monthly_summary AS (
  SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity
  FROM sales.orders
  GROUP BY order_month
);

-- Main Query:
SELECT * 
FROM sales.v_monthly_summary;

-- Updating a View
-- MySQL does not support ALTER VIEW

DROP VIEW IF EXISTS sales.v_monthly_summary;
CREATE VIEW sales.v_monthly_summary AS (...);

CREATE OR REPLACE VIEW sales_summary AS
SELECT 
  customer_id,
  COUNT(*) AS total_orders,
  SUM(amount) AS total_sales
FROM orders
GROUP BY customer_id;

-- Drop a View
DROP VIEW sales.v_monthly_summary;
```

## Execution Order

1. User queries a **view**
2. SQL engine retrieves the **stored query** for that view
3. SQL engine **executes the view’s query** against underlying tables
4. SQL engine **executes the user’s query** using the view’s result
5. Only **metadata and SQL query** are stored – no user data inside views

## Views vs CTEs


| Feature            | CTE                 | View                                 |
| -------------------- | --------------------- | -------------------------------------- |
| Scope              | One query only      | Stored, reusable in many queries     |
| Duration           | Temporary           | Persisted until dropped              |
| Performance        | Slightly faster     | May be slower if nested or complex   |
| Use Case           | Inline logic reuse  | Central logic, security, abstraction |
| Maintenance Effort | None (auto-cleanup) | Manual (create/drop/update)          |

## Best Practices

- Use views for **logic you expect to reuse**
- Use **CTEs** for **ad-hoc query-specific transformations**
- Always use **schemas** to organize views
- Keep views **simple and readable** for performance
- Consider **materialized views** (in other DBs) if performance is a concern

## Important Notes & Limitations

1. Views are usually read-only
   • You can’t INSERT, UPDATE, or DELETE unless the view meets very strict criteria (no joins, no aggregation, etc.)
2. No Indexes
   • Views do not have indexes. Indexes are applied on the underlying tables.
3. Performance
   • Every time you query a view, MySQL executes the underlying SQL. Complex views can slow down queries.
4. No Materialized Views
   • MySQL views are not persisted — they are always executed on demand.
   • If you want pre-computed results, you’ll need to create a physical table and update it manually.

## When to Use Views (Use Cases)


| **Use Case**                           | **Example**                           |
| ---------------------------------------- | --------------------------------------- |
| Simplify complex joins                 | customer_orders_summary               |
| Hide sensitive data                    | public_employee_info                  |
| Create reporting layers                | monthly_sales_summary                 |
| Provide different views for user roles | admin_view, analyst_view              |
| Normalize repeating query logic        | Shared logic in dashboards or reports |
