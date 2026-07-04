# String Functions

---

## 1. What are Built-in Functions?

Relational databases do more than just store and retrieve raw data. They also provide powerful **built-in functions** to manipulate and transform that data *before* it is sent to your application.

This chapter covers **String Functions**, which allow you to manipulate text (`VARCHAR`, `TEXT`) directly inside your SQL queries.

---

## 2. Concatenation (Joining Strings)

### CONCAT()
Combines two or more strings into one single string.
```sql
-- Combine first and last name with a space in between
SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM users;
```
*Note: If any of the arguments in `CONCAT` is `NULL`, the entire result becomes `NULL`.*

### CONCAT_WS()
"Concatenate With Separator". This is a much safer alternative to `CONCAT`. The first argument is the separator, and it automatically skips any `NULL` values instead of destroying the whole string.
```sql
-- Returns "John, Doe, New York". If last_name was NULL, it returns "John, New York".
SELECT CONCAT_WS(', ', first_name, last_name, city) 
FROM users;
```

---

## 3. Formatting Strings

### UPPER() and LOWER()
Converts a string to all uppercase or all lowercase.
```sql
SELECT UPPER(email) FROM users;
SELECT LOWER(first_name) FROM users;
```
*Use Case:* Normalizing user input before inserting it into the database, or doing case-insensitive comparisons if your collation isn't already case-insensitive.

### TRIM(), LTRIM(), RTRIM()
Removes whitespace (spaces, tabs) from the beginning or end of a string.
*   `TRIM()`: Removes from both sides.
*   `LTRIM()`: Removes from the Left side only.
*   `RTRIM()`: Removes from the Right side only.
```sql
-- Cleans up messy user input like "   John   "
SELECT TRIM(first_name) FROM users;
```

---

## 4. Extracting and Replacing

### SUBSTRING() / SUBSTR()
Extracts a specific portion of a string. You provide the string, the starting position, and the number of characters to extract.
**(Important: In SQL, strings are 1-indexed, meaning the first character is position 1, not 0!)**

```sql
-- Start at position 1, extract 3 characters -> 'App'
SELECT SUBSTRING('Apple', 1, 3);

-- If you omit the length, it extracts everything from the start position to the end. -> 'ple'
SELECT SUBSTRING('Apple', 3);
```

### LENGTH() and CHAR_LENGTH()
Returns the length of a string.
*   `LENGTH()`: Returns the length in **Bytes**.
*   `CHAR_LENGTH()`: Returns the length in **Characters**.
*Always use `CHAR_LENGTH()` when dealing with human text, because a single Emoji or Chinese character might be 4 bytes long, but it is only 1 character.*
```sql
SELECT CHAR_LENGTH(password) FROM users;
```

### REPLACE()
Searches a string and replaces all occurrences of a specific substring with a new substring.
```sql
-- Changes 'I love cats' to 'I love dogs'
SELECT REPLACE('I love cats', 'cats', 'dogs');

-- Removing dashes from phone numbers
SELECT REPLACE(phone_number, '-', '') FROM users;
```

---

## 5. Interview Tips
*   **1-Indexed vs 0-Indexed:** If asked to write a `SUBSTRING` query on a whiteboard, loudly mention, "I am starting at index 1, because SQL string functions are 1-indexed, unlike Python or Java which are 0-indexed." This shows deep, practical experience.
*   **Handling NULLs in CONCAT:** Interviewers love testing if you know that `CONCAT('A', NULL, 'B')` results in `NULL`. Always suggest `CONCAT_WS` or using `COALESCE` to handle potential NULLs when concatenating.
