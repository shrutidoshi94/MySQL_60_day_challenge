# CODING ORDER VS EXECUTION ORDER


| Coding Order | Execution Order |
| -------------- | ----------------- |
| `SELECT`     | `FROM`          |
| `FROM`       | `ON`            |
| `ON`         | `JOIN`          |
| `JOIN`       | `WHERE`         |
| `WHERE`      | `GROUP BY`      |
| `GROUP BY`   | `HAVING`        |
| `HAVING`     | `SELECT`        |
| `DISTINCT`   | `DISTINCT`      |
| `ORDER BY`   | `ORDER BY`      |
| `LIMIT`      | `LIMIT`         |
