**Q1. Which SQL clause is used to extract only those records that fulfill a specified condition?**
A) ORDER BY
B) FILTER
C) WHERE
D) HAVING

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The WHERE clause is specifically designed to filter records in a query based on specified conditions before any grouping occurs.
</details>

**Q2. Which operator is used to search for a specified pattern in a column?**
A) MATCH
B) LIKE
C) IN
D) SEARCH

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The LIKE operator is used in a WHERE clause to search for a specified pattern within a column's values.
</details>

**Q3. What does the `%` wildcard represent when used with the LIKE operator?**
A) Exactly one character
B) Any single number
C) Zero, one, or multiple characters
D) A space character

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The percent sign (`%`) represents zero, one, or multiple characters in a string pattern when using the LIKE operator.
</details>

**Q4. Which wildcard represents exactly one character when used with the LIKE operator?**
A) %
B) -
C) *
D) _

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The underscore (`_`) wildcard is used to match exactly one single character in a specific position within a string.
</details>

**Q5. How would you select all records where the `City` column starts with the letter 'a'?**
A) SELECT * FROM Customers WHERE City = 'a%';
B) SELECT * FROM Customers WHERE City LIKE 'a%';
C) SELECT * FROM Customers WHERE City LIKE '%a';
D) SELECT * FROM Customers WHERE City LIKE 'a_';

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `LIKE 'a%'` matches any string that starts with 'a' followed by zero or more characters.
</details>

**Q6. How would you select all records where the `City` column ends with the letter 'a'?**
A) SELECT * FROM Customers WHERE City LIKE '%a%';
B) SELECT * FROM Customers WHERE City LIKE 'a%';
C) SELECT * FROM Customers WHERE City LIKE '%a';
D) SELECT * FROM Customers WHERE City = '%a';

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `LIKE '%a'` matches any string that has zero or more characters preceding an 'a' at the very end.
</details>

**Q7. What will `WHERE name LIKE '%or%'` match?**
A) Names starting with 'or' only
B) Names ending with 'or' only
C) Names containing 'or' in any position
D) Names that are exactly 'or'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Using the `%` wildcard on both sides of a substring matches values containing that substring in any position.
</details>

**Q8. Which query will find names that have 'r' in the second position?**
A) WHERE name LIKE '_r%'
B) WHERE name LIKE '%r_'
C) WHERE name LIKE 'r_%'
D) WHERE name LIKE '__r%'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The underscore `_` matches exactly one character (the first character), followed by 'r', and `%` matches any remaining characters.
</details>

**Q9. Which operator allows you to specify multiple values in a WHERE clause without using multiple OR conditions?**
A) LIKE
B) IN
C) BETWEEN
D) EXISTS

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The IN operator acts as a shorthand for multiple OR conditions, allowing you to check if a value matches any in a list.
</details>

**Q10. How do you find customers whose `City` is either 'Paris' or 'London' using the IN operator?**
A) WHERE City IN 'Paris', 'London'
B) WHERE City IN ('Paris', 'London')
C) WHERE City = IN ('Paris', 'London')
D) WHERE City IN ('Paris' AND 'London')

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The correct syntax for the IN operator requires the values to be enclosed in parentheses and separated by commas.
</details>

**Q11. Which operator selects values within a given range, inclusive of the boundaries?**
A) RANGE
B) WITHIN
C) BETWEEN
D) IN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The BETWEEN operator selects values within a given range. In MySQL, the boundaries are included by default.
</details>

**Q12. What is the correct syntax for using the BETWEEN operator?**
A) WHERE column_name BETWEEN value1 AND value2
B) WHERE column_name BETWEEN (value1, value2)
C) WHERE column_name BETWEEN value1 TO value2
D) WHERE column_name BETWEEN value1, value2

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The BETWEEN operator is used in conjunction with the AND operator to specify the start and end values.
</details>

**Q13. How would you select all records where the value of the `Price` column is NOT between 10 and 20?**
A) WHERE Price NOT (BETWEEN 10 AND 20)
B) WHERE Price NOT BETWEEN 10 AND 20
C) WHERE NOT Price BETWEEN 10 TO 20
D) WHERE Price BETWEEN 10 AND 20 NOT

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NOT BETWEEN` is the correct syntax to exclude values falling within a specific range.
</details>

**Q14. How do you check for NULL values in a table?**
A) WHERE column_name = NULL
B) WHERE column_name IS NULL
C) WHERE column_name == NULL
D) WHERE column_name AS NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You cannot use standard comparison operators like `=` to test for NULL. You must use the `IS NULL` operator.
</details>

**Q15. How do you return only records where a specified column is not empty (not NULL)?**
A) WHERE column_name IS NOT NULL
B) WHERE column_name != NULL
C) WHERE column_name NOT NULL
D) WHERE column_name <> NULL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `IS NOT NULL` is the correct standard SQL operator used to filter out NULL values.
</details>

**Q16. What will be the result of the expression `NULL = NULL` in a WHERE clause?**
A) TRUE
B) FALSE
C) NULL (Unknown)
D) 1

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In SQL, comparing anything to NULL, even another NULL, using standard operators results in an unknown value (NULL), not TRUE.
</details>

**Q17. Which logical operator requires both conditions to be true for a record to be included in the result set?**
A) OR
B) ANY
C) ALL
D) AND

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The AND operator displays a record if all the conditions separated by AND are TRUE.
</details>

**Q18. Which logical operator requires at least one condition to be true for a record to be included?**
A) AND
B) OR
C) XOR
D) IN

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The OR operator displays a record if any one of the conditions separated by OR is TRUE.
</details>

**Q19. What operator is used to reverse the truth value of a condition?**
A) REVERSE
B) INVERT
C) NOT
D) MINUS

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The NOT operator displays a record if the condition(s) is NOT TRUE.
</details>

**Q20. In what order are logical operators evaluated by default in MySQL?**
A) NOT, AND, OR
B) AND, OR, NOT
C) OR, AND, NOT
D) Left to right, regardless of operator

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Operator precedence dictates that NOT is evaluated first, followed by AND, and finally OR, unless parentheses are used.
</details>

**Q21. Given `WHERE A OR B AND C`, which part is evaluated first?**
A) A OR B
B) B AND C
C) A OR C
D) It depends on left-to-right evaluation

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** AND has a higher precedence than OR. Thus, `B AND C` is evaluated first, and the result is then ORed with A.
</details>

**Q22. How can you override the default precedence of AND and OR operators?**
A) Using square brackets []
B) Using quotes ""
C) Using parentheses ()
D) By placing the OR at the beginning of the query

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Parentheses `()` can be used to explicitly define the order of evaluation, forcing the conditions inside them to be evaluated first.
</details>

**Q23. Which of the following is equivalent to `WHERE City != 'Berlin' AND City != 'London'`?**
A) WHERE City NOT IN ('Berlin', 'London')
B) WHERE City NOT ('Berlin', 'London')
C) WHERE NOT City IN 'Berlin', 'London'
D) WHERE City IN NOT ('Berlin', 'London')

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `NOT IN` is a concise way to exclude multiple specific values, effectively replacing multiple `!=` combined with `AND`.
</details>

**Q24. What does the `!=` operator do in MySQL?**
A) Assigns a value
B) Checks for equality
C) Checks for inequality (Not Equal)
D) Compares for greater than

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `!=` operator checks if two values are not equal. The `<>` operator functions exactly the same way.
</details>

**Q25. Can the `IN` operator be used with subqueries?**
A) No, IN only accepts literal values.
B) Yes, but only with numeric data.
C) Yes, IN can evaluate the result set of a subquery.
D) No, you must use EXISTS for subqueries.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The IN operator is very frequently used with subqueries to filter data based on a list of values returned by another query.
</details>

**Q26. What happens if you use `BETWEEN 'A' AND 'C'` on a text column?**
A) It causes an error because BETWEEN is only for numbers.
B) It matches values starting with A, B, and only exactly 'C'.
C) It matches all values starting with A, B, and C.
D) It converts the letters to ASCII codes and performs a numeric comparison.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In alphabetical sorting, strings like 'Cat' are considered greater than 'C'. Therefore, it will match 'A...', 'B...', but only exactly 'C'.
</details>

**Q27. How does MySQL handle case sensitivity in a standard `LIKE` string comparison?**
A) It is case-sensitive by default.
B) It is case-insensitive by default.
C) It depends on the operating system.
D) `LIKE` only works with lowercase strings.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By default, character set collations in MySQL (like `utf8mb4_0900_ai_ci`) are case-insensitive (`_ci`), making `LIKE` case-insensitive.
</details>

**Q28. Which of the following conditions correctly finds records where the `description` is exactly 5 characters long?**
A) WHERE description LIKE '_____' (five underscores)
B) WHERE description = '5'
C) WHERE description LIKE '%5%'
D) WHERE description IN (5)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Each underscore (`_`) matches exactly one character, so five underscores match any string that is exactly five characters long.
</details>

**Q29. What is the result of `SELECT * FROM table WHERE 1=0;`?**
A) All rows in the table
B) An empty result set
C) A syntax error
D) Only the first row of the table

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `1=0` is a condition that always evaluates to FALSE. Therefore, no rows will meet the condition, returning an empty set.
</details>

**Q30. Which operator evaluates to TRUE if the operand is within a list of expressions?**
A) BETWEEN
B) IN
C) LIKE
D) EQUALS

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The IN operator is used to determine if a specified value matches any value in a defined list or subquery.
</details>

**Q31. How do you find customers whose names start with 'a' and are at least 3 characters in length?**
A) WHERE name LIKE 'a__%'
B) WHERE name LIKE 'a%' AND length > 3
C) WHERE name LIKE 'a_%'
D) WHERE name LIKE 'a_3'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `a` matches the first character, `_` matches the second, `_` matches the third, and `%` allows for any additional characters.
</details>

**Q32. In a WHERE clause, `val BETWEEN 10 AND 20` is exactly equivalent to:**
A) val > 10 AND val < 20
B) val >= 10 AND val <= 20
C) val > 10 OR val < 20
D) val >= 10 OR val <= 20

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The BETWEEN operator is inclusive, meaning it equates to greater than or equal to the first value AND less than or equal to the second value.
</details>

**Q33. What will `WHERE name NOT LIKE 'A%'` do?**
A) Return names starting with 'A'.
B) Return names ending with 'A'.
C) Return names that do NOT start with 'A'.
D) Result in a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Combining `NOT` with `LIKE` negates the pattern match, so it filters for records that do not match the specified pattern.
</details>

**Q34. What is the standard SQL comparison operator for "Less than or equal to"?**
A) =<
B) <=
C) <+
D) =!

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `<` is less than, and `=` is equal to. The combined operator for "less than or equal to" is `<=`.
</details>

**Q35. If you want to include rows where `status` is 'Active' or 'Pending', but NOT 'Deleted', which query is best?**
A) WHERE status IN ('Active', 'Pending')
B) WHERE status = 'Active' AND status = 'Pending'
C) WHERE status NOT IN ('Deleted')
D) Both A and C would work, depending on other possible statuses.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** If the only other status is 'Deleted', both `IN ('Active', 'Pending')` and `!= 'Deleted'` will yield the same result. However, IN is more explicit if new statuses are added later.
</details>

**Q36. When combining AND and OR without parentheses, which of the following is evaluated first: `WHERE A OR B AND C`?**
A) A OR B
B) A AND C
C) B AND C
D) Left to right

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `AND` has a higher operator precedence than `OR`. Therefore, the `B AND C` condition is evaluated before the `OR` condition.
</details>

**Q37. Which statement successfully selects all employees in department 10 with a salary over 50000?**
A) SELECT * FROM employees WHERE department = 10 OR salary > 50000;
B) SELECT * FROM employees WHERE department = 10 AND salary > 50000;
C) SELECT * FROM employees WHERE department = 10, salary > 50000;
D) SELECT * FROM employees WHERE department = 10 & salary > 50000;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `AND` operator must be used to ensure both conditions (department is 10 AND salary is greater than 50000) are met simultaneously.
</details>

**Q38. Can the `IN` operator be used with date values in MySQL?**
A) Yes, if they are formatted correctly as strings (e.g., 'YYYY-MM-DD').
B) No, IN only works with integers.
C) No, IN only works with varchars.
D) Yes, but only with UNIX timestamps.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL can implicitly convert formatted date strings to DATE values, making them perfectly valid for use inside an `IN` clause.
</details>

**Q39. How can you find records where the `comments` column contains an actual percentage sign `%`?**
A) WHERE comments LIKE '%\%%'
B) WHERE comments LIKE '%p%'
C) WHERE comments LIKE '%%%'
D) WHERE comments LIKE '%*%*'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** To match a literal wildcard character like `%`, you must escape it using the backslash `\` character by default in MySQL.
</details>

**Q40. What is the result of applying the `NOT` operator to a condition that evaluates to `NULL`?**
A) TRUE
B) FALSE
C) NULL
D) 0

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In three-valued logic, `NOT NULL` evaluates to `NULL`. The truth value remains unknown.
</details>

**Q41. Which expression effectively checks if a numeric column `score` is an even number?**
A) WHERE score % 2 = 0
B) WHERE score / 2 = 0
C) WHERE score EVEN = TRUE
D) WHERE MOD(score) = 2

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The modulo operator `%` (or `MOD()`) returns the remainder of a division. If `score % 2` is 0, the number is even.
</details>

**Q42. How does `WHERE col1 <> col2` behave if `col1` is NULL?**
A) It returns TRUE.
B) It returns FALSE.
C) It evaluates to NULL (Unknown).
D) It throws a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Standard comparison operators (`=`, `<>`, `<`, `>`) always yield NULL when either operand is NULL.
</details>

**Q43. Which MySQL operator is the NULL-safe equal to operator?**
A) ==
B) ===
C) <=>
D) =:=

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The spaceship operator `<=>` performs a NULL-safe comparison. It returns 1 (TRUE) if both operands are NULL, and 0 (FALSE) if only one is NULL.
</details>

**Q44. `WHERE id NOT BETWEEN 10 AND 20` is logically equivalent to:**
A) WHERE id < 10 OR id > 20
B) WHERE id <= 10 OR id >= 20
C) WHERE id < 10 AND id > 20
D) WHERE id <= 10 AND id >= 20

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `BETWEEN 10 AND 20` includes 10 and 20. Therefore, `NOT BETWEEN` means strictly less than 10 OR strictly greater than 20.
</details>

**Q45. What will the query `SELECT 1 WHERE 'A' = 'a';` return in a default MySQL setup?**
A) 1
B) An empty set
C) A syntax error
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** By default, string comparisons in MySQL (using standard collations) are case-insensitive, so 'A' is considered equal to 'a'.
</details>

**Q46. What does the `XOR` operator do in a WHERE clause?**
A) Returns TRUE if both conditions are true.
B) Returns TRUE if at least one condition is true.
C) Returns TRUE if exactly one condition is true, but not both.
D) Reverses the boolean value of a condition.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** XOR (Exclusive OR) evaluates to TRUE if and only if one condition is TRUE and the other is FALSE. If both are TRUE, it returns FALSE.
</details>

**Q47. If you have `WHERE (A OR B) AND C`, and A is TRUE, B is FALSE, C is TRUE. What is the final evaluation?**
A) TRUE
B) FALSE
C) NULL
D) Unknown

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** (TRUE OR FALSE) evaluates to TRUE. Then, TRUE AND TRUE evaluates to TRUE.
</details>

**Q48. How would you filter for records where the `Title` starts with 'The' and contains the word 'Lord'?**
A) WHERE Title LIKE 'The%Lord%'
B) WHERE Title LIKE 'The * Lord'
C) WHERE Title LIKE 'The_' AND Title LIKE '%Lord%'
D) WHERE Title LIKE 'The%' OR Title LIKE '%Lord%'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `The%` ensures it starts with 'The', and `Lord%` allows 'Lord' to appear anywhere after that, followed by any characters.
</details>

**Q49. In the context of `IN`, how many values can you include in the list?**
A) Maximum 100
B) Maximum 255
C) There is a theoretical limit based on `max_allowed_packet`, but practically thousands.
D) Exactly 10

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The number of values in an IN clause is limited by the `max_allowed_packet` size setting in MySQL, meaning it can handle a very large number of items.
</details>

**Q50. Which operator tests if a subquery returns any rows?**
A) IN
B) EXISTS
C) ANY
D) ALL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The EXISTS operator returns TRUE if the subquery returns one or more records, making it highly efficient for checking existence.
</details>
