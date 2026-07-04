# Module 2 – Filtering

---

## Question 11

### Difficulty
Easy

### SQL Concepts Covered
* WHERE
* LIKE (Wildcard matching)

### Objective
Perform a partial string match.

### Problem Statement
Find all countries whose name starts with the letter 'Z'. Return the Name.

### Tables Used
* `country`

### Hint
Use the `%` wildcard character to represent "any number of characters".

### Expected Learning Outcome
Using the `LIKE` operator with the `%` wildcard for prefix matching.

### Solution (MySQL)
```sql
SELECT 
    Name 
FROM country
WHERE Name LIKE 'Z%';
```

### Explanation
* `LIKE 'Z%'`: The `%` is a wildcard that matches zero or more characters. 'Z%' means the string must start with 'Z', followed by anything.

### Dry Run
1. Engine evaluates 'Zambia' -> Starts with Z. Keep.
2. Engine evaluates 'Zimbabwe' -> Starts with Z. Keep.
3. Engine evaluates 'New Zealand' -> Starts with N. Discard.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name FROM country WHERE LEFT(Name, 1) = 'Z';
```
*Pros/Cons:* The `LIKE` operator is heavily preferred because `LIKE 'Z%'` is SARGable (can use an index). The `LEFT()` function breaks the index (Full Table Scan).

### Common Mistakes
* Using `=` instead of `LIKE` (e.g., `Name = 'Z%'`). This literally looks for a country named exactly "Z%".

### Interview Tip
Always mention SARGability when discussing `LIKE`. A wildcard at the *end* (`'Z%'`) can use an index. A wildcard at the *beginning* (`'%Z'`) cannot use a B-Tree index.

### Related Concepts
* SARGability
* Index Range Scans

---

## Question 12

### Difficulty
Easy

### SQL Concepts Covered
* WHERE
* NOT LIKE

### Objective
Exclude rows based on a partial string match.

### Problem Statement
Find all countries in the 'Europe' continent whose name does NOT end with the letter 'a'.

### Tables Used
* `country`

### Hint
Combine `AND` with the negation of the `LIKE` operator.

### Expected Learning Outcome
Using `NOT LIKE` and suffix matching.

### Solution (MySQL)
```sql
SELECT 
    Name 
FROM country
WHERE Continent = 'Europe' 
  AND Name NOT LIKE '%a';
```

### Explanation
* `NOT LIKE '%a'`: The `%` is at the beginning, meaning it matches any prefix, but the string *must* end with 'a'. The `NOT` inverts this logic, keeping only countries that don't end in 'a'.

### Dry Run
1. 'Albania' -> Ends with 'a'. Evaluates to FALSE. Discard.
2. 'France' -> Ends with 'e'. Evaluates to TRUE. Keep.
3. 'Germany' -> Ends with 'y'. Evaluates to TRUE. Keep.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name FROM country WHERE Continent = 'Europe' AND RIGHT(Name, 1) != 'a';
```
*Pros/Cons:* Again, string functions like `RIGHT()` are generally avoided in the WHERE clause, though in this specific case, `LIKE '%a'` is not SARGable anyway, so performance is roughly identical.

### Common Mistakes
* Writing `LIKE NOT '%a'` instead of `NOT LIKE '%a'`.

### Interview Tip
Queries with leading wildcards (`%a`) always result in Full Table Scans (or Full Index Scans) because the B-Tree cannot jump to the middle or end of a string.

### Related Concepts
* Full Table Scans

---

## Question 13

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* IS NULL

### Objective
Find records with missing data.

### Problem Statement
Find the Name of all countries that do NOT have a recognized Head of State. (The column is empty/null).

### Tables Used
* `country`

### Hint
You cannot use the equals sign (`=`) to check for nothingness.

### Expected Learning Outcome
Understanding that `NULL` represents an unknown value, and requires special operators.

### Solution (MySQL)
```sql
SELECT 
    Name 
FROM country
WHERE HeadOfState IS NULL;
```

### Explanation
* `IS NULL`: This is the only valid way to check if a database cell contains the special `NULL` marker.

### Dry Run
1. Evaluates USA ('George W. Bush'). Not null. Discard.
2. Evaluates Antarctica (NULL). Is null. Keep.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Writing `WHERE HeadOfState = NULL`. Because `NULL` means "Unknown", comparing anything to `NULL` (even another `NULL`) results in `NULL` (Falsy), not `TRUE`.

### Interview Tip
"How do you check for NULLs?" is a classic junior-level interview question. Knowing the difference between `= NULL` and `IS NULL` is mandatory.

### Related Concepts
* Three-Valued Logic (True, False, Unknown)
* COALESCE

---

## Question 14

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* IS NOT NULL
* AND

### Objective
Filter out missing data.

### Problem Statement
Find all countries that gained independence (`IndepYear`) after 1900, but ensure you exclude any countries where the Independence Year is not recorded.

### Tables Used
* `country`

### Hint
You need two conditions in your WHERE clause.

### Expected Learning Outcome
Using `IS NOT NULL` in conjunction with other filters.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    IndepYear 
FROM country
WHERE IndepYear > 1900 
  AND IndepYear IS NOT NULL;
```

### Explanation
* `IndepYear > 1900`: Checks the year.
* `IndepYear IS NOT NULL`: Explicitly guarantees we don't include rows with missing data. *(Note: in SQL, `NULL > 1900` evaluates to UNKNOWN, which filters out the row anyway, but explicitly writing `IS NOT NULL` is excellent for readability).*

### Dry Run
1. 'Czech Republic' (1993) -> >1900 AND Not Null. Keep.
2. 'Antarctica' (NULL) -> Fails first condition, fails second condition. Discard.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, IndepYear 
FROM country
WHERE IndepYear > 1900;
```
*Pros/Cons:* Functionally identical because `NULL > 1900` removes the row, but the explicit `IS NOT NULL` proves your intent to other developers.

### Common Mistakes
* Writing `IndepYear != NULL`.

### Interview Tip
Handling `NULL`s correctly is critical in reporting. Always ask your interviewer: "How should we handle NULL values in this data?" before writing your query.

### Related Concepts
* Filtering UNKNOWN logic

---

## Question 15

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* NOT Operator
* IN Operator

### Objective
Exclude a list of specific values.

### Problem Statement
List the Name and Continent of all countries that are NOT located in 'Asia', 'Europe', or 'North America'.

### Tables Used
* `country`

### Hint
Combine the `NOT` keyword with the `IN` keyword.

### Expected Learning Outcome
Using `NOT IN` to cleanly exclude multiple exact matches.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Continent 
FROM country
WHERE Continent NOT IN ('Asia', 'Europe', 'North America');
```

### Explanation
* `NOT IN (...)`: Returns TRUE if the column value does not match any of the values in the provided list.

### Dry Run
1. 'Japan' (Asia) -> In list. Discard.
2. 'Brazil' (South America) -> Not in list. Keep.
3. 'Fiji' (Oceania) -> Not in list. Keep.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, Continent 
FROM country
WHERE Continent != 'Asia' 
  AND Continent != 'Europe' 
  AND Continent != 'North America';
```
*Pros/Cons:* This works, but is much harder to read. (Note the use of `AND`, not `OR`, when negating multiple values).

### Common Mistakes
* Using `NOT IN` when the list contains a `NULL` value. `NOT IN (1, 2, NULL)` will ALWAYS return 0 rows for the entire query due to Three-Valued Logic. (Safe here because Continent has no NULLs).

### Interview Tip
If an interviewer asks you to use `NOT IN` with a subquery, always mention the `NULL` trap. If the subquery returns a `NULL`, the entire outer query fails. Use `NOT EXISTS` instead.

### Related Concepts
* NOT EXISTS
* The NULL Trap

---

## Question 16

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* Complex AND/OR Logic
* Parentheses

### Objective
Control the order of operations when combining AND and OR.

### Problem Statement
Find all cities in the database that have a population greater than 5 million (5,000,000) AND are located in either the 'USA' or 'CHN' (China).

### Tables Used
* `city`

### Hint
Without parentheses, `AND` runs before `OR`. You must use parentheses to group the country logic together.

### Expected Learning Outcome
Mastering Operator Precedence (BODMAS for SQL).

### Solution (MySQL)
```sql
SELECT 
    Name, 
    CountryCode, 
    Population 
FROM city
WHERE Population > 5000000 
  AND (CountryCode = 'USA' OR CountryCode = 'CHN');
```

### Explanation
* `(CountryCode = 'USA' OR CountryCode = 'CHN')`: The parentheses force the database to evaluate this `OR` condition as a single logical block.
* The query requires: (Population > 5M) AND (Is USA or CHN).

### Dry Run
1. 'New York', USA, 8008278 -> >5M (T) AND (USA(T) or CHN(F) -> T) = T AND T. Keep.
2. 'Shanghai', CHN, 9696300 -> >5M (T) AND (USA(F) or CHN(T) -> T) = T AND T. Keep.
3. 'Tokyo', JPN, 7980230 -> >5M (T) AND (USA(F) or CHN(F) -> F) = T AND F. Discard.

### SQL Execution Order
1. FROM
2. WHERE (Evaluates parentheses first, then the AND)
3. SELECT

### Alternative Solution
```sql
SELECT Name, CountryCode, Population 
FROM city
WHERE Population > 5000000 
  AND CountryCode IN ('USA', 'CHN');
```
*Pros/Cons:* Using `IN` completely avoids the parenthesis precedence issue and is vastly preferred in professional code.

### Common Mistakes
* Writing `WHERE Population > 5000000 AND CountryCode = 'USA' OR CountryCode = 'CHN'`. Because `AND` has higher precedence, this translates to: "(Pop > 5M AND USA) OR (Any city in China regardless of population)".

### Interview Tip
Questions testing `AND`/`OR` precedence are extremely common in multiple-choice screening tests. Always look for the missing parentheses.

### Related Concepts
* Operator Precedence

---

## Question 17

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* Multiple NOT logic

### Objective
Exclude rows based on multiple intersecting conditions.

### Problem Statement
Find all countries that are in 'Europe', but exclude any countries that have a population under 10,000 OR a surface area under 1,000.

### Tables Used
* `country`

### Hint
Start by isolating 'Europe'. Then, add a condition that says `NOT (...)` wrapping the two exclusions.

### Expected Learning Outcome
Applying De Morgan's Laws in SQL.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Population, 
    SurfaceArea 
FROM country
WHERE Continent = 'Europe'
  AND NOT (Population < 10000 OR SurfaceArea < 1000);
```

### Explanation
* `NOT (A OR B)`: Excludes the row if either A or B is true.

### Dry Run
1. 'Monaco' (Pop 34000, Area 1.5). Pop < 10k (F) OR Area < 1000 (T) = True. NOT (True) = False. Discard.
2. 'France' (Pop 59M, Area 551k). Pop < 10k (F) OR Area < 1000 (F) = False. NOT (False) = True. Keep.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, Population, SurfaceArea 
FROM country
WHERE Continent = 'Europe'
  AND Population >= 10000 
  AND SurfaceArea >= 1000;
```
*Pros/Cons:* By applying De Morgan's Law (`NOT(A OR B) = NOT A AND NOT B`), we flip the logic. This alternative solution is much easier for humans to read and understand.

### Common Mistakes
* Writing `AND Population >= 10000 OR SurfaceArea >= 1000` (Precedence error).

### Interview Tip
Transforming negative logic (`NOT`) into positive logic (`>= AND >=`) is a great way to show clean coding practices during an interview.

### Related Concepts
* De Morgan's Laws

---

## Question 18

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* LIKE (Single Character Wildcard)

### Objective
Match strings based on specific character positions.

### Problem Statement
Find all countries whose `Code2` (the two-letter country code) starts with 'U', and the second letter is anything. 

### Tables Used
* `country`

### Hint
The `%` wildcard matches zero or more characters. The `_` (underscore) wildcard matches exactly one character.

### Expected Learning Outcome
Using the `_` wildcard for precise string matching.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Code2 
FROM country
WHERE Code2 LIKE 'U_';
```

### Explanation
* `LIKE 'U_'`: Looks for exactly two characters. The first must be 'U'. The second can be anything (`_`).

### Dry Run
1. 'US' -> Matches U, matches _. Keep.
2. 'UK' -> Matches U, matches _. Keep.
3. 'UGA' -> Code2 is only 2 letters in the schema, but if it were 3, it would fail because `_` only matches exactly 1 character, whereas `%` would match 'GA'.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, Code2 FROM country WHERE LEFT(Code2, 1) = 'U' AND LENGTH(Code2) = 2;
```
*Pros/Cons:* The `LIKE` approach is much more concise and index-friendly.

### Common Mistakes
* Using `%` instead of `_` when exact length matters.

### Interview Tip
The `_` wildcard is rarely used in real life but is a favorite trivia question for SQL interviews to see if you know wildcards beyond `%`.

### Related Concepts
* Wildcards

---

## Question 19

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* Handling empty strings vs NULLs

### Objective
Differentiate between an empty string and a NULL value.

### Problem Statement
Find all countries where the `LocalName` is exactly the same as the `Name`. Then, find any where the `LocalName` is a completely empty string (not NULL, just empty).

### Tables Used
* `country`

### Hint
You can compare two columns to each other in the `WHERE` clause. An empty string is represented by `''`.

### Expected Learning Outcome
Comparing columns and understanding `'' != NULL`.

### Solution (MySQL)
```sql
-- Part 1: LocalName equals Name
SELECT Name 
FROM country 
WHERE Name = LocalName;

-- Part 2: LocalName is empty string
SELECT Name 
FROM country 
WHERE LocalName = '';
```

### Explanation
* `Name = LocalName`: The database compares the value of column A to column B row-by-row.
* `LocalName = ''`: Checks for a string of zero length. This is distinctly different from `IS NULL`.

### Dry Run
1. 'France', LocalName 'France' -> Matches.
2. If a country had LocalName `''`, the second query would catch it.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Thinking `IS NULL` and `= ''` are the same thing. `NULL` is the absence of data. `''` is actual data (a string with 0 characters).

### Interview Tip
"What is the difference between NULL and an empty string?" -> NULL is undefined/unknown. An empty string is a known, defined value of zero length. (Note: Oracle treats empty strings as NULL, but MySQL and SQL Server do not).

### Related Concepts
* Column-to-Column Comparison

---

## Question 20

### Difficulty
Hard

### SQL Concepts Covered
* SELECT
* CASE
* Multiple Conditions

### Objective
Create a custom categorization based on filtering logic.

### Problem Statement
Retrieve the Name, Population, and a new column called `SizeCategory`.
If the population is greater than 100,000,000, categorize it as 'Huge'.
If it is between 50,000,000 and 100,000,000 (inclusive), categorize as 'Large'.
Otherwise, categorize as 'Normal'.

### Tables Used
* `country`

### Hint
Use a `CASE` statement in the `SELECT` clause to evaluate conditions row by row.

### Expected Learning Outcome
Using `CASE WHEN` to dynamically generate data based on filters.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Population,
    CASE
        WHEN Population > 100000000 THEN 'Huge'
        WHEN Population BETWEEN 50000000 AND 100000000 THEN 'Large'
        ELSE 'Normal'
    END AS SizeCategory
FROM country;
```

### Explanation
* `CASE WHEN ... THEN ... ELSE ... END`: Evaluates conditions sequentially. The first condition that is TRUE is applied, and the CASE statement exits. If none are true, it falls back to the `ELSE`.

### Dry Run
1. 'China' (Pop 1.2B) -> Hits first WHEN (>100M). Evaluates to 'Huge'.
2. 'France' (Pop 59M) -> Fails first WHEN. Hits second WHEN (Between 50M and 100M). Evaluates to 'Large'.
3. 'Aruba' (Pop 103k) -> Fails first two. Hits ELSE. Evaluates to 'Normal'.

### SQL Execution Order
1. FROM
2. SELECT (CASE is evaluated here per row)

### Alternative Solution
```sql
SELECT 
    Name, 
    Population,
    CASE
        WHEN Population > 100000000 THEN 'Huge'
        WHEN Population >= 50000000 THEN 'Large' -- We don't need <= 100M!
        ELSE 'Normal'
    END AS SizeCategory
FROM country;
```
*Pros/Cons:* Because `CASE` evaluates sequentially, if a population is 150M, it hits the first condition and exits. Therefore, by the time it reaches the second condition, we *already know* it is <= 100M. We only need to check `>= 50000000`. This is cleaner.

### Common Mistakes
* Forgetting the `END` keyword.
* Forgetting the `ELSE` fallback, resulting in `NULL` for anything that doesn't match a `WHEN`.

### Interview Tip
`CASE` statements are the SQL equivalent of `if/else` statements. They are incredibly powerful for transforming data for reporting and are frequently tested in data analyst interviews.

### Related Concepts
* Conditional Logic
* IF() function (MySQL specific)
