# **CODING ORDER VS EXECUTION ORDER**

| **Coding Order (Written By You)** | **Execution Order (Run By Database)** |
| --------------------------------- | ------------------------------------- |
| 1\. SELECT                        | 1\. FROM                              |
| 2\. FROM                          | 2\. JOIN (if any)                     |
| 3\. JOIN (if any)                 | 3\. WHERE                             |
| 4\. WHERE                         | 4\. GROUP BY                          |
| 5\. GROUP BY                      | 5\. HAVING                            |
| 6\. HAVING                        | 6\. SELECT                            |
| 7\. ORDER BY                      | 7\. ORDER BY                          |
| 8\. LIMIT                         | 8\. LIMIT                             |

