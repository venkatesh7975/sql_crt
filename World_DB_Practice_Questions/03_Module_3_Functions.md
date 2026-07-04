# Module 3 – Functions

---

## Question 21

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* String Functions: `UPPER()`, `LOWER()`
* `CONCAT()`

### Objective
Format output strings for uniform presentation.

### Problem Statement
Generate a formatted string for every country in 'South America'. The output should look exactly like: `COUNTRY: [Uppercase Name] - code: [lowercase code]`. (e.g., "COUNTRY: BRAZIL - code: bra"). Name this column `FormattedString`.

### Tables Used
* `country`

### Hint
You will need to combine three different string functions together to build the final output.

### Expected Learning Outcome
Mastering basic string manipulation and concatenation.

### Solution (MySQL)
```sql
SELECT 
    CONCAT('COUNTRY: ', UPPER(Name), ' - code: ', LOWER(Code)) AS FormattedString
FROM country
WHERE Continent = 'South America';
```

### Explanation
* `UPPER(Name)`: Converts the entire country name to uppercase.
* `LOWER(Code)`: Converts the 3-letter code to lowercase.
* `CONCAT(...)`: Joins multiple strings together into one continuous string.

### Dry Run
1. Engine finds 'Brazil', Code 'BRA'.
2. UPPER('Brazil') -> 'BRAZIL'. LOWER('BRA') -> 'bra'.
3. CONCAT('COUNTRY: ', 'BRAZIL', ' - code: ', 'bra') -> 'COUNTRY: BRAZIL - code: bra'.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT (String functions and CONCAT are applied here)

### Alternative Solution
```sql
SELECT 
    CONCAT_WS(' ', 'COUNTRY:', UPPER(Name), '-', 'code:', LOWER(Code)) AS FormattedString
FROM country
WHERE Continent = 'South America';
```
*Pros/Cons:* `CONCAT_WS` (Concat With Separator) automatically inserts the first argument (a space) between all other arguments. It handles NULLs better than `CONCAT`, but for this exact formatting requirement, standard `CONCAT` is slightly cleaner.

### Common Mistakes
* Trying to use the `+` operator for string concatenation (e.g., `'COUNTRY: ' + Name`). The `+` operator is for math in MySQL; it will try to convert the strings to numbers and return `0`. (SQL Server uses `+`, Oracle uses `||`).

### Interview Tip
Always default to `CONCAT()` in MySQL. If an interviewer asks how to handle a situation where one of the columns might be `NULL` (which would make standard `CONCAT()` return `NULL`), mention `CONCAT_WS()` or `COALESCE()`.

### Related Concepts
* String Concatenation across SQL Dialects

---

## Question 22

### Difficulty
Medium

### SQL Concepts Covered
* String Functions: `LENGTH()`, `CHAR_LENGTH()`
* `ORDER BY` with Functions

### Objective
Understand the difference between bytes and characters.

### Problem Statement
Find the top 5 countries with the longest names (character count). Return the Name and the number of characters. If there is a tie in length, sort alphabetically.

### Tables Used
* `country`

### Hint
Some characters (like emojis or special accents) take up multiple bytes. You need the function that counts *characters*, not *bytes*.

### Expected Learning Outcome
Differentiating `LENGTH()` and `CHAR_LENGTH()`.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    CHAR_LENGTH(Name) AS NameLength
FROM country
ORDER BY CHAR_LENGTH(Name) DESC, Name ASC
LIMIT 5;
```

### Explanation
* `CHAR_LENGTH(Name)`: Counts the number of human-readable characters in the string.
* `LENGTH(Name)`: Counts the number of *bytes* in the string. (A 1-character emoji might have a LENGTH of 4, but a CHAR_LENGTH of 1).
* `ORDER BY ... DESC, Name ASC`: Primary sort is length (longest first). Secondary sort is alphabetical.

### Dry Run
1. Calculates length for all countries.
2. Sorts descending by length. 'South Georgia and the South Sandwich Islands' (44 chars) is at the top.
3. Limits to 5 rows.

### SQL Execution Order
1. FROM
2. SELECT
3. ORDER BY
4. LIMIT

### Alternative Solution
N/A

### Common Mistakes
* Using `LENGTH()` instead of `CHAR_LENGTH()`. While they often return the same number for standard English ASCII text, `LENGTH()` will fail on international characters (UTF-8).

### Interview Tip
This is a classic "gotcha" question for Senior Engineers. If you blindly use `LENGTH()`, the interviewer will immediately ask: "What happens if the name is written in Kanji or contains an é?" You must know the difference between bytes and chars.

### Related Concepts
* Character Encodings (UTF-8 vs ASCII)

---

## Question 23

### Difficulty
Medium

### SQL Concepts Covered
* String Functions: `SUBSTRING()`
* `DISTINCT`

### Objective
Extract a portion of a string.

### Problem Statement
Find all the unique first letters of the Country names in the database.

### Tables Used
* `country`

### Hint
You need to extract a substring starting at position 1, with a length of 1.

### Expected Learning Outcome
Using `SUBSTRING` or `LEFT` to parse strings.

### Solution (MySQL)
```sql
SELECT DISTINCT 
    SUBSTRING(Name, 1, 1) AS FirstLetter
FROM country
ORDER BY FirstLetter ASC;
```

### Explanation
* `SUBSTRING(string, start_position, length)`: Extracts a chunk of text. Note that SQL strings are **1-indexed**, not 0-indexed like most programming languages.
* `SUBSTRING(Name, 1, 1)`: Start at character 1, grab 1 character.

### Dry Run
1. 'Aruba' -> Substring -> 'A'.
2. 'Afghanistan' -> Substring -> 'A'.
3. DISTINCT removes the second 'A'.

### SQL Execution Order
1. FROM
2. SELECT (Substring applied)
3. DISTINCT
4. ORDER BY

### Alternative Solution
```sql
SELECT DISTINCT LEFT(Name, 1) AS FirstLetter 
FROM country 
ORDER BY FirstLetter ASC;
```
*Pros/Cons:* `LEFT()` is syntactic sugar for `SUBSTRING(col, 1, n)`. It is cleaner and preferred when you strictly want a prefix.

### Common Mistakes
* Assuming SQL strings are 0-indexed. `SUBSTRING(Name, 0, 1)` will fail or return empty in standard SQL.

### Interview Tip
String parsing in SQL is notoriously slow. If you find yourself heavily using `SUBSTRING` in a `WHERE` clause or `JOIN` condition, it indicates a bad database design.

### Related Concepts
* LEFT()
* RIGHT()

---

## Question 24

### Difficulty
Easy

### SQL Concepts Covered
* String Functions: `REPLACE()`

### Objective
Modify string contents.

### Problem Statement
The database stores "United States" in the Name column. Write a query to retrieve the names of all countries in North America, but replace the word "United" with "Divided" wherever it appears.

### Tables Used
* `country`

### Hint
The replace function takes three arguments: the column, the word to find, and the word to substitute.

### Expected Learning Outcome
Using the `REPLACE()` function to sanitize or modify data on the fly.

### Solution (MySQL)
```sql
SELECT 
    REPLACE(Name, 'United', 'Divided') AS ModifiedName
FROM country
WHERE Continent = 'North America';
```

### Explanation
* `REPLACE(string, search_string, replacement_string)`: Scans the string. Every instance of the `search_string` is swapped out for the `replacement_string`.

### Dry Run
1. 'Canada' -> Does not contain 'United'. Remains 'Canada'.
2. 'United States' -> Contains 'United'. Becomes 'Divided States'.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT (Replace applied)

### Alternative Solution
N/A

### Common Mistakes
* Using `REPLACE` to update the actual database table by accident. (As written above in a `SELECT` statement, it only modifies the *output*, not the underlying data).

### Interview Tip
`REPLACE()` is case-sensitive in many databases, but in MySQL, it depends on the collation of the column (usually case-insensitive by default for text columns).

### Related Concepts
* UPDATE with REPLACE()

---

## Question 25

### Difficulty
Medium

### SQL Concepts Covered
* Numeric Functions: `ROUND()`, `CEIL()`, `FLOOR()`

### Objective
Manipulate decimal outputs.

### Problem Statement
Find the LifeExpectancy of all countries in 'Oceania'. 
Return three columns:
1. The exact LifeExpectancy rounded to 0 decimal places.
2. The LifeExpectancy forcibly rounded UP to the nearest integer.
3. The LifeExpectancy forcibly rounded DOWN to the nearest integer.

Ignore any countries where LifeExpectancy is NULL.

### Tables Used
* `country`

### Hint
Think about the ceiling of a room (up) and the floor of a room (down).

### Expected Learning Outcome
Mastering mathematical rounding functions.

### Solution (MySQL)
```sql
SELECT 
    Name,
    ROUND(LifeExpectancy, 0) AS Rounded_Normal,
    CEIL(LifeExpectancy) AS Rounded_Up,
    FLOOR(LifeExpectancy) AS Rounded_Down
FROM country
WHERE Continent = 'Oceania'
  AND LifeExpectancy IS NOT NULL;
```

### Explanation
* `ROUND(col, decimals)`: Standard mathematical rounding. (e.g., 71.5 becomes 72. 71.4 becomes 71).
* `CEIL(col)`: Ceiling. Always rounds UP to the next integer. (e.g., 71.1 becomes 72).
* `FLOOR(col)`: Floor. Always rounds DOWN to the previous integer. (e.g., 71.9 becomes 71).

### Dry Run
1. 'Australia' (79.8). ROUND(0) = 80. CEIL = 80. FLOOR = 79.
2. 'Fiji' (67.9). ROUND(0) = 68. CEIL = 68. FLOOR = 67.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Confusing `ROUND(col, 0)` with `FLOOR()`. `ROUND` goes to the *nearest* whole number, `FLOOR` just chops off the decimal completely (for positive numbers).

### Interview Tip
If working with financial data (currency), standard floating-point math causes rounding errors. Always store money as `DECIMAL(10,2)` in MySQL, not `FLOAT`, to ensure `ROUND()` behaves deterministically.

### Related Concepts
* TRUNCATE() / TRUNC()
* Floating Point Math Issues
