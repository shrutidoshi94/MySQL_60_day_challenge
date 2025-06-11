# 1. Basic Syntax

```sql
DELETE
-- [LOW_PRIORITY | QUICK | IGNORE]
FROM tbl_name
-- [WHERE where_condition]
-- [ORDER BY ...]
-- [LIMIT row_count];
```

ORDER BY + LIMIT lets you delete a subset, e.g. the oldest 10 rows:

```sql
DELETE FROM logs
ORDER BY created_at ASC
LIMIT 10;
```
## 2. Single-Table vs. Multi-Table Deletes

```sql
-- **Single-Table**
DELETE
  FROM Person
  WHERE status = 'inactive';
```

```sql
-- **Multi-Table (via JOIN)**
-- Delete orders for customers marked “inactive”
DELETE o
  FROM Orders AS o
  JOIN Customers AS c
    ON o.customer_id = c.id
 WHERE c.status = 'inactive';
```

### To delete from multiple tables:
```sql
DELETE o, c
  FROM Orders AS o
  JOIN Customers AS c
    ON o.customer_id = c.id
 WHERE c.status = 'closed';
```

## 3. Why GROUP BY / HAVING Aren’t Allowed Directly
MySQL’s DELETE grammar does not include GROUP BY or HAVING. 

```sql
DELETE FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
```
**`ERROR 1064 (42000): You have an error in your SQL syntax...`**

```sql
-- wrapping wrongly:
DELETE FROM Person
WHERE id IN (
  SELECT MAX(id), email
  FROM Person
  GROUP BY email
);
```

**`ERROR 1241 (21000): Subquery returns more than 1 column`**
**`ERROR 1093 (HY000): You can't specify target table 'Person' for update in FROM clause`**

Reason:
	1.	MySQL separates modification (DELETE) from retrieval (SELECT) in its parser.
	2.	Aggregates must live in SELECT or subqueries, not top-level DELETE.

## 4. Supported Patterns for “Group-Based” Deletes

To delete rows based on an aggregate condition (e.g. “remove all but the smallest id per email”), identify target id values via a subquery or join, then feed that into DELETE.

### 4.1 Derived-Table + IN
```sql
-- Keep the smallest id per email, delete the rest:
DELETE FROM Person
WHERE id IN (
  SELECT dup_id
  FROM (
    SELECT MAX(id) AS dup_id
      FROM Person
     GROUP BY email
    HAVING COUNT(*) > 1
  ) AS derived
);
```

Inner subquery returns one column (dup_id), wrapped in a derived table so MySQL allows the deletion.

### 4.2 JOIN to a Derived Table

```sql
-- Delete the highest id for each duplicate email:
DELETE p
  FROM Person AS p
  JOIN (
    SELECT email, MAX(id) AS dup_id
      FROM Person
     GROUP BY email
    HAVING COUNT(*) > 1
  ) AS d
    ON p.email = d.email
   AND p.id    = d.dup_id;
```

The derived table d pinpoints which id to delete; joining back to Person AS p targets those rows.

## 5. Deleting Duplicates by Grouping (Summary)

### 	1.	JOIN-delete – keep the smallest id per email:
```sql
DELETE p2
  FROM Person AS p1
  JOIN Person AS p2
    ON p1.email = p2.email
   AND p1.id    < p2.id;
```

### 	2.	NOT IN subquery – delete every row whose id isn’t the minimum:
```sql
DELETE FROM Person
WHERE id NOT IN (
  SELECT keep_id
  FROM (
    SELECT MIN(id) AS keep_id
      FROM Person
     GROUP BY email
  ) AS t
);
```

## 6. Transactions & Foreign Keys

**Transactions**
```sql
START TRANSACTION;
  DELETE …;
-- ROLLBACK; or COMMIT;
```

**Foreign-Key Constraints**
Without ON DELETE CASCADE, you must delete dependents first.
```sql
ALTER TABLE Orders
  ADD CONSTRAINT fk_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(id)
    ON DELETE CASCADE;
```

## 7. Performance & Safety Tips

**Preview with SELECT**
```sql
SELECT *
FROM my_table
WHERE …;
```

**Batch deletes for large tables:**
```sql
DELETE FROM big_table
WHERE status = 'old'
LIMIT 10000;
```

TRUNCATE vs. DELETE
	•	TRUNCATE: faster, non-transactional, resets auto-increment, skips triggers.
	•	DELETE: transactional (InnoDB), fires triggers, respects FKs.
 
## 8. Common Pitfalls & Key Takeaways
	•	Top-level DELETE cannot include GROUP BY/HAVING.
	•	Use aggregation in a subquery (wrapped as a derived table) or JOIN.
	•	Always test deletion logic with a SELECT first.
	•	Leverage LIMIT/ORDER BY to control which rows are removed.
	•	Account for foreign-key constraints and consider transactions for safety.
