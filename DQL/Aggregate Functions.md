## 5.3 AGGREGATE function

**5.3.1 Basic Aggregate Functions**

| **Function** | **Description** | **Syntax** |
| --- | --- | --- |
| `COUNT()` | Counts rows (or non-NULL values) | COUNT(*) or COUNT(column) |
| `SUM()` | Calculates the total sum of a numeric column | SUM(column) |
| `AVG()` | Calculates the average of a numeric column | AVG(column) |
| `MIN()` | Returns the minimum value in a column | MIN(column) |
| `MAX()` | Returns the maximum value in a column | MAX(column) |
| `GROUP_CONCAT()` | Concatenates strings from multiple rows into a single string, grouped by GROUP BY | GROUP_CONCAT(column SEPARATOR ', ') |

**Key Differences Between CONCAT() and GROUP_CONCAT()**

| **Feature** | CONCAT() | GROUP_CONCAT() |
| --- | --- | --- |
| Type | **Scalar function** | **Aggregate function** |
| Operates on | **Columns in a single row** | **Multiple rows within a group** |
| Used with GROUP BY? | Not required | Often used with GROUP BY |
| Example Use | Full name: CONCAT(first_name, ' ', last_name) | List of names: GROUP_CONCAT(name) |
| Returns | One string per row | One string per group |

**5.3.2 Statistical Aggregate Functions**

| `STDDEV()` | Returns the standard deviation of a numeric column | STDDEV(column) |
| --- | --- | --- |
| `STDDEV_POP()` | Standard deviation (population version, synonym of STDDEV) | STDDEV_POP(column) |
| `VARIANCE()` | Returns the statistical variance of a numeric column | VARIANCE(column) |
| `VAR_POP()` | Population variance (like VARIANCE) | VAR_POP(column) |

**5.3.3 BIT Aggregate Functions**

| `BIT_AND()` | Bitwise AND of all non-NULL values | BIT_AND(column) |
| --- | --- | --- |
| `BIT_OR()` | Bitwise OR of all non-NULL values | BIT_OR(column) |
| `BIT_XOR()` | Bitwise XOR of all non-NULL values | BIT_XOR(column) |

**5.3.4 JSON Aggregate functions**

| `JSON_ARRAYAGG()` | Aggregates values into a JSON array (MySQL 5.7+) | JSON_ARRAYAGG(column) |
| --- | --- | --- |
| `JSON_OBJECTAGG()` | Aggregates key-value pairs into a JSON object (MySQL 5.7+) | JSON_OBJECTAGG(key, value) |

