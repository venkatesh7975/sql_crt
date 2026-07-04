# Problem 45 – Patients With a Condition

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* String Matching (`LIKE`, `REGEXP`)
* Logical Operators (`OR`)

---

## 3. Pattern
Substring Filtering / Regex

---

## 4. Problem Statement
Write a SQL query to find the `patient_id`, `patient_name`, and `conditions` of the patients who have Type I Diabetes. 
Type I Diabetes always starts with the **`DIAB1`** prefix.
Return the result table in any order.

---

## 5. Tables

Table: Patients

| Column       | Type    |
| ------------ | ------- |
| patient_id   | INT     |
| patient_name | VARCHAR |
| conditions   | VARCHAR |

* `patient_id` is the primary key.
* `conditions` contains 0 or more code separated by spaces. 

---

## 6. Sample Input

Patients table:

| patient_id | patient_name | conditions   |
| ---------- | ------------ | ------------ |
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |

---

## 7. Expected Output

| patient_id | patient_name | conditions   |
| ---------- | ------------ | ------------ |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |

*(Bob has DIAB100, which starts with DIAB1. George has ACNE and DIAB100. Alain has DIAB201, which is Type II, not Type I).*

---

## 8. Understanding the Question
What information is being asked? Details of patients with a specific condition.
What columns are important? `conditions`.
What conditions matter? The code `DIAB1` must be present. Because conditions are separated by spaces, the code could be the *first* condition in the string, or it could appear *later* in the string, preceded by a space.
What should be returned? `patient_id`, `patient_name`, `conditions`.

---

## 9. Thinking Process
1. I need to search inside a string. I can use the `LIKE` operator with wildcard characters (`%`).
2. **Scenario 1:** The patient's very first condition is Type I Diabetes.
   * Example: `"DIAB100 MYOP"`.
   * Condition: `conditions LIKE 'DIAB1%'`. (Starts with DIAB1, followed by anything).
3. **Scenario 2:** The condition is listed second, third, etc.
   * Example: `"ACNE DIAB100"`.
   * Condition: `conditions LIKE '% DIAB1%'`. (Starts with anything, then a **space**, then DIAB1, followed by anything).
4. **The Trap:** What if I just use `conditions LIKE '%DIAB1%'`?
   * If a patient has a condition called `"SADIAB100"`, the wildcard `%DIAB1%` would match it! But `"SADIAB100"` is a totally different disease. 
   * This is why we must strictly check for the beginning of the string (`'DIAB1%'`) OR a space prefix (`'% DIAB1%'`).
5. Combine them: `WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%'`.

---

## 10. Approach 1 (Optimal)
LIKE with OR conditions

Check the two possible valid occurrences of the string: at the very beginning, or preceded by a space.

---

## 11. SQL Solution

```sql
-- Find patients with Type I Diabetes (DIAB1 prefix)
SELECT 
    patient_id, 
    patient_name, 
    conditions
FROM 
    Patients
WHERE 
    conditions LIKE 'DIAB1%' 
    OR conditions LIKE '% DIAB1%';
```

---

## 12. Step-by-Step Dry Run
1. **Row 1 ('YFEV COUGH'):**
   * Starts with DIAB1? No.
   * Contains ' DIAB1'? No.
2. **Row 3 ('DIAB100 MYOP'):**
   * Starts with DIAB1? **Yes.** (`'DIAB1%'` matches).
3. **Row 4 ('ACNE DIAB100'):**
   * Starts with DIAB1? No.
   * Contains ' DIAB1'? **Yes.** (`'% DIAB1%'` matches because of the space before DIAB).
4. **Row 5 ('DIAB201'):**
   * Starts with DIAB1? No.
   * Contains ' DIAB1'? No.

---

## 13. SQL Execution Order
1. **FROM Patients:** Reads the table.
2. **WHERE:** Applies the string matching logic.
3. **SELECT:** Returns the matching rows.

---

## 14. Query Breakdown
* **LIKE:** Performs pattern matching.
* **% (Percent sign):** Represents zero, one, or multiple characters.
* **_ (Underscore):** Represents a single character (not used here, but good to know).
* **'% DIAB1%' (Notice the space):** Crucial for ensuring we are matching the *beginning of a word* within the space-separated list, rather than the middle of another random word.

---

## 15. Why This Solution Works
It strictly adheres to the space-separated format of the data while avoiding false positives from substrings embedded inside other words.

---

## 16. Alternative Solution
Using Regular Expressions (REGEXP)

MySQL supports regular expressions, which can solve this in a single, elegant string pattern.

```sql
SELECT 
    patient_id, 
    patient_name, 
    conditions
FROM 
    Patients
WHERE 
    conditions REGEXP '\\bDIAB1';
```
*(Note: Some older versions of MySQL prefer `REGEXP '(^| )DIAB1'`)*

* **Advantages:** `\b` represents a "word boundary". It automatically checks if `DIAB1` is at the start of the string or preceded by a space/punctuation. It is much cleaner than writing multiple `LIKE` statements.
* **Disadvantages:** Regex engines are slightly slower than simple `LIKE` pattern matchers, and Regex syntax varies wildly between different SQL dialects (Postgres uses `~`, SQL Server uses `PATINDEX`).

---

## 17. Time Complexity
**O(N)**. The database must scan every single row and perform string matching. String matching with leading wildcards (`% DIAB1`) cannot utilize standard B-Tree indexes, so a Full Table Scan is guaranteed.

---

## 18. Common Mistakes
* **Using only `LIKE '%DIAB1%'`:** As explained, this will incorrectly match strings like `"RADIAB100"`.
* **Forgetting the space in `'% DIAB1%'`:** If you write `'%DIAB1%'`, you just recreated the mistake above.
* **Using `AND` instead of `OR`:** A patient will not have the condition at the *beginning* of the string AND at the *end* of the string simultaneously. Use `OR`.

---

## 19. Edge Cases
* **Only one condition:** e.g., `"DIAB1"`. Handled perfectly by `LIKE 'DIAB1%'`.
* **Condition is at the end:** e.g., `"COUGH DIAB1"`. Handled perfectly by `LIKE '% DIAB1%'`.

---

## 20. Interview Tips
* If an interviewer asks you to parse space-separated or comma-separated lists stored in a single column, mention that **this violates First Normal Form (1NF) of database normalization**. The proper schema design would be a separate `PatientConditions` bridging table with one row per condition. Finding data via `LIKE '% %'` is an anti-pattern caused by bad database design!

---

## 21. Similar LeetCode Problems
* 1667. Fix Names in a Table
* 1517. Find Users With Valid E-Mails (Regex)

---

## 22. Key Takeaways
* When searching for a specific "word" in a space-separated string, you must check if it's the first word (`'WORD%'`) OR if it's preceded by a space (`'% WORD%'`).
* `REGEXP '\\bWORD'` is the professional way to do word-boundary matching if your SQL dialect supports it.
