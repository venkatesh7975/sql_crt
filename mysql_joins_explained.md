# MySQL JOINS Explained with Examples

A **JOIN** is used to combine rows from **two or more tables** based on a related column.

## Sample Tables

### `customers`
| customer_id | customer_name |
| ----------- | ------------- |
| 1           | Alice         |
| 2           | Bob           |
| 3           | Charlie       |
| 4           | David         |

### `orders`
| order_id | customer_id | product  |
| -------- | ----------- | -------- |
| 101      | 1           | Laptop   |
| 102      | 1           | Mouse    |
| 103      | 2           | Keyboard |
| 104      | 5           | Mobile   |

Notice:
* Alice has **2 orders**
* Bob has **1 order**
* Charlie and David have **no orders**
* Order **104** belongs to customer **5**, who doesn't exist in the customers table.

---

# 1. INNER JOIN

### Definition
Returns **only the matching records** from both tables.

### Syntax
```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
```

### Example
```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```

### Output
| customer_name | product  |
| ------------- | -------- |
| Alice         | Laptop   |
| Alice         | Mouse    |
| Bob           | Keyboard |

### Explanation
* Charlie → No order ❌
* David → No order ❌
* Order 104 → No matching customer ❌

Only matching rows are returned.

---

# 2. LEFT JOIN

### Definition
Returns **all rows from the left table** and matching rows from the right table.
If no match exists, the right-side columns become `NULL`.

### Syntax
```sql
SELECT *
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id;
```

### Example
```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Output
| customer_name | product  |
| ------------- | -------- |
| Alice         | Laptop   |
| Alice         | Mouse    |
| Bob           | Keyboard |
| Charlie       | NULL     |
| David         | NULL     |

### Explanation
Every customer is shown.
Customers without orders get `NULL`.

---

# 3. RIGHT JOIN

### Definition
Returns **all rows from the right table** and matching rows from the left table.

### Example
```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Output
| customer_name | product  |
| ------------- | -------- |
| Alice         | Laptop   |
| Alice         | Mouse    |
| Bob           | Keyboard |
| NULL          | Mobile   |

### Explanation
Order **104** belongs to customer_id **5**.
Since customer 5 doesn't exist,
Customer becomes `NULL`.

---

# 4. FULL OUTER JOIN

## MySQL does NOT support FULL OUTER JOIN directly.
We simulate it using `UNION`.

### Query
```sql
SELECT
    c.customer_name,
    o.product
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id

UNION

SELECT
    c.customer_name,
    o.product
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```

### Output
| customer_name | product  |
| ------------- | -------- |
| Alice         | Laptop   |
| Alice         | Mouse    |
| Bob           | Keyboard |
| Charlie       | NULL     |
| David         | NULL     |
| NULL          | Mobile   |

### Explanation
Returns everything from both tables.

---

# 5. CROSS JOIN

### Definition
Returns the **Cartesian Product**.
Every row in table A joins with every row in table B.

### Example
```sql
SELECT
    customer_name,
    product
FROM customers
CROSS JOIN orders;
```

### Output
4 customers × 4 orders = **16 rows**

| Customer | Product  |
| -------- | -------- |
| Alice    | Laptop   |
| Alice    | Mouse    |
| Alice    | Keyboard |
| Alice    | Mobile   |
| Bob      | Laptop   |
| Bob      | Mouse    |
| ...      | ...      |

### Formula
`Rows = m × n`

If `Customers = 100`, `Orders = 500`
Output: `100 × 500 = 50,000 rows`

---

# 6. SELF JOIN

### Definition
A table joins with itself.
Useful for:
* Employee → Manager
* Parent → Child
* Friend Relationships
* Category Hierarchies

### Employee Table
| emp_id | name  | manager_id |
| ------ | ----- | ---------- |
| 1      | John  | NULL       |
| 2      | Alice | 1          |
| 3      | Bob   | 1          |
| 4      | David | 2          |

### Query
```sql
SELECT
    e.name AS Employee,
    m.name AS Manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;
```

### Output
| Employee | Manager |
| -------- | ------- |
| John     | NULL    |
| Alice    | John    |
| Bob      | John    |
| David    | Alice   |

---

# JOIN Comparison

| Join            | Returns                                                     |
| --------------- | ----------------------------------------------------------- |
| INNER JOIN      | Only matching rows from both tables                         |
| LEFT JOIN       | All rows from the left table + matching rows from the right |
| RIGHT JOIN      | All rows from the right table + matching rows from the left |
| FULL OUTER JOIN | All rows from both tables (simulate with `UNION` in MySQL)  |
| CROSS JOIN      | Every row from table A × every row from table B             |
| SELF JOIN       | A table joined with itself                                  |

---

# Interview Questions

1. What is a JOIN?
2. Difference between INNER JOIN and LEFT JOIN?
3. Difference between LEFT JOIN and RIGHT JOIN?
4. Does MySQL support FULL OUTER JOIN?
5. How do you simulate a FULL OUTER JOIN in MySQL?
6. What is a CROSS JOIN, and when would you use it?
7. What is a SELF JOIN? Give a real-world example.
8. What happens if there are duplicate values in the join column?
9. What is the difference between `ON` and `WHERE` in JOINs?
10. How do indexes on join columns improve JOIN performance?
