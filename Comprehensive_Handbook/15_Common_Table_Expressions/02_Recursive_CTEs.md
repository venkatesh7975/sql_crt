# Recursive CTEs

---

## 1. The Hierarchical Data Problem

Relational databases are great at flat grids, but they struggle with hierarchical or tree-like data.

Imagine an `employees` table where every employee has a `manager_id` pointing to another employee. 
*   How do you write a query to find all direct reports of the CEO? (Easy, one Self Join).
*   How do you find the direct reports of the direct reports? (Harder, two Self Joins).
*   **How do you find the entire management chain of an intern, going all the way up to the CEO, regardless of how many levels deep it is?**

You cannot solve an unknown depth problem with standard Joins. You need a loop.
SQL provides this loop via the **Recursive CTE**.

---

## 2. Anatomy of a Recursive CTE

A Recursive CTE is a CTE that references its own name inside its definition. 
It requires the `WITH RECURSIVE` keyword in MySQL.

It consists of three mandatory parts:
1.  **The Anchor Member:** The starting point of the loop (e.g., "Find the CEO").
2.  **The UNION ALL:** Connects the anchor to the loop.
3.  **The Recursive Member:** The query that loops, referencing the CTE itself, until it returns 0 rows.

---

## 3. Example 1: Generating Numbers

The simplest way to understand a Recursive CTE is to use it to generate a sequence of numbers from 1 to 5.

```sql
WITH RECURSIVE NumberGenerator AS (
    -- 1. Anchor Member: This runs exactly once to start the loop.
    SELECT 1 AS num
    
    UNION ALL
    
    -- 2. Recursive Member: This loops until the WHERE clause fails.
    SELECT num + 1 
    FROM NumberGenerator -- References itself!
    WHERE num < 5
)
-- 3. Main Query
SELECT * FROM NumberGenerator;
```
**Execution Steps:**
1.  Anchor runs. Outputs `1`.
2.  Loop 1 runs, looking at the previous output (`1`). 1 < 5 is True. Outputs `1 + 1 = 2`.
3.  Loop 2 runs, looking at previous output (`2`). 2 < 5 is True. Outputs `2 + 1 = 3`.
4.  Loop 3 outputs `4`.
5.  Loop 4 outputs `5`.
6.  Loop 5 looks at `5`. 5 < 5 is False. Loop terminates.

---

## 4. Example 2: Traversing an Employee Hierarchy

Let's solve the management chain problem. We want to find the CEO and every employee underneath them, assigning them a "Level" (CEO = 1, VP = 2, Manager = 3, etc.).

```sql
WITH RECURSIVE OrgChart AS (
    -- Anchor: Find the CEO (the guy with no manager)
    SELECT 
        id, 
        name, 
        manager_id, 
        1 AS hierarchy_level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: Join the employees table to the previous loop's output
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        oc.hierarchy_level + 1 -- Increment the level
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.id
)
SELECT * FROM OrgChart ORDER BY hierarchy_level;
```

---

## 5. Interview Tips
*   **The Infinite Loop Danger:** "What happens if your recursive CTE has a bug and creates an infinite loop?"
    *   **Answer:** "In a real database, it would eventually crash the server due to memory exhaustion. However, database engines have safety nets. MySQL has a setting called `cte_max_recursion_depth` (default is 1000). If the loop hits 1001, the database forcibly kills the query to protect the server."
*   **When to use them:** If an interview question mentions words like "Tree", "Hierarchy", "Graph", "BOM (Bill of Materials)", or "Parent-Child relationships of unknown depth", immediately reach for a Recursive CTE.
