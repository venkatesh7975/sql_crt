# MySQL 8.0 Multiple Choice Questions: String and Math Functions (Part 1)

**Q1. What is the result of `SELECT CONCAT('MySQL', NULL, '8.0');` in MySQL?**
A) MySQL8.0
B) MySQL NULL 8.0
C) NULL
D) An error is returned

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, the CONCAT() function returns NULL if any of its arguments are NULL.
</details>

**Q2. Which function is used to concatenate strings with a specified separator and ignores NULL values?**
A) CONCAT_SEP()
B) CONCAT_WS()
C) JOIN_STR()
D) STRING_AGG()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CONCAT_WS() stands for "Concatenate With Separator". It skips any NULL values in the list of strings to be concatenated.
</details>

**Q3. What does `SELECT SUBSTRING('Database', 1, 4);` return?**
A) base
B) Data
C) atab
D) Datab

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SUBSTRING(string, start, length) begins at the 1-based index 1 ('D') and extracts 4 characters, resulting in 'Data'.
</details>

**Q4. What is the output of `SELECT SUBSTRING('Database', -4);`?**
A) base
B) Data
C) atab
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A negative starting position means the function starts counting from the end of the string. The last 4 characters are 'base'.
</details>

**Q5. What will `SELECT REPLACE('MySQL', 'SQL', 'DB');` produce?**
A) MySQL
B) MyDB
C) MYDB
D) DB

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The REPLACE() function substitutes all occurrences of the second argument ('SQL') in the first string with the third argument ('DB').
</details>

**Q6. Is the REPLACE() function in MySQL case-sensitive?**
A) Yes, it performs a case-sensitive match.
B) No, it performs a case-insensitive match.
C) Only if the database collation is case-insensitive.
D) It depends on the operating system.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** REPLACE() performs a case-sensitive search when looking for substrings to replace in MySQL.
</details>

**Q7. What is the difference between LENGTH() and CHAR_LENGTH() in MySQL?**
A) There is no difference; they are synonymous.
B) LENGTH() measures characters; CHAR_LENGTH() measures bytes.
C) LENGTH() measures bytes; CHAR_LENGTH() measures characters.
D) LENGTH() excludes trailing spaces; CHAR_LENGTH() includes them.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LENGTH() returns the length of a string in bytes, while CHAR_LENGTH() returns the number of characters, which matters for multi-byte character sets like UTF-8.
</details>

**Q8. What does `SELECT UPPER('mysql');` return?**
A) mysql
B) Mysql
C) MYSQL
D) MySQL

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The UPPER() function converts all characters in the string to uppercase.
</details>

**Q9. Which function converts a string to lowercase in MySQL?**
A) LOW()
B) LCASE()
C) DOWN()
D) Both B and LOWER()

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** In MySQL, both LOWER() and LCASE() can be used to convert strings to lowercase, as they are synonyms.
</details>

**Q10. What will `SELECT LTRIM('  text');` return?**
A) 'text  '
B) '  text  '
C) 'text'
D) '  text'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LTRIM() removes all leading (left-side) spaces from the string.
</details>

**Q11. What will `SELECT RTRIM('text  ');` return?**
A) '  text'
B) 'text  '
C) 'text'
D) '  text  '

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** RTRIM() removes all trailing (right-side) spaces from the string.
</details>

**Q12. What does `SELECT TRIM(BOTH 'x' FROM 'xtextx');` evaluate to?**
A) 'xtextx'
B) 'text'
C) 'textx'
D) 'xtext'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The TRIM() function can remove specified prefixes or suffixes. Using BOTH removes 'x' from both ends of the string.
</details>

**Q13. What is the output of `SELECT LEFT('MySQL', 2);`?**
A) 'My'
B) 'QL'
C) 'SQ'
D) 'M'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** LEFT() extracts the specified number of characters from the left side (start) of the string.
</details>

**Q14. What does `SELECT RIGHT('MySQL', 3);` return?**
A) 'MyS'
B) 'SQL'
C) 'ySQ'
D) 'QL '

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** RIGHT() extracts the specified number of characters from the right side (end) of the string.
</details>

**Q15. What will `SELECT LOCATE('S', 'MySQL');` return?**
A) 1
B) 2
C) 3
D) 4

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LOCATE(substr, str) returns the 1-based starting position of the first occurrence of the substring. 'S' is the 3rd character in 'MySQL'.
</details>

**Q16. What does `SELECT INSTR('MySQL', 'S');` return?**
A) 3
B) 4
C) 2
D) 0

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** INSTR(str, substr) returns the position of the first occurrence of a substring. It is similar to LOCATE but with arguments reversed.
</details>

**Q17. What will `SELECT ROUND(123.456, 2);` yield?**
A) 123.45
B) 123.46
C) 123.50
D) 123.00

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ROUND() rounds the number to the specified number of decimal places. The third decimal digit is 6, so it rounds up to 123.46.
</details>

**Q18. What is the output of `SELECT ROUND(123.456, -1);`?**
A) 120
B) 130
C) 123.4
D) 123.5

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A negative second argument in ROUND() specifies rounding to the left of the decimal point. The nearest multiple of 10 to 123 is 120.
</details>

**Q19. What will `SELECT CEIL(123.01);` return?**
A) 123
B) 124
C) 123.1
D) 123.0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CEIL() (or CEILING()) returns the smallest integer value not less than the specified number. It always rounds up.
</details>

**Q20. What is the output of `SELECT FLOOR(123.99);`?**
A) 124
B) 123
C) 123.9
D) 120

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FLOOR() returns the largest integer value not greater than the specified number. It always rounds down.
</details>

**Q21. What does `SELECT CEIL(-123.99);` return?**
A) -123
B) -124
C) 124
D) 123

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Since CEIL() rounds up to the next highest integer, -123 is greater than -123.99.
</details>

**Q22. What does `SELECT FLOOR(-123.01);` return?**
A) -123
B) -124
C) 124
D) 123

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FLOOR() rounds down. Since -124 is less than -123.01, it returns -124.
</details>

**Q23. What will `SELECT ABS(-15);` yield?**
A) -15
B) 15
C) 0
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ABS() returns the absolute (positive) value of a given number.
</details>

**Q24. What does `SELECT TRUNCATE(123.456, 2);` return?**
A) 123.46
B) 123.45
C) 123.00
D) 120.00

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** TRUNCATE() truncates the number to the specified number of decimal places without rounding. Thus, 123.456 becomes 123.45.
</details>

**Q25. What is the output of `SELECT TRUNCATE(123.456, -1);`?**
A) 123.4
B) 123.5
C) 120
D) 130

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** With a negative second argument, TRUNCATE() replaces digits to the left of the decimal point with zeros without rounding. 123 truncated at the tens place is 120.
</details>

**Q26. What does `SELECT MOD(10, 3);` return?**
A) 3
B) 1
C) 0
D) 3.33

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MOD(N, M) returns the remainder of N divided by M. 10 divided by 3 has a remainder of 1.
</details>

**Q27. Which operator is equivalent to the MOD() function in MySQL?**
A) /
B) %
C) //
D) **

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `%` operator is the modulo operator in MySQL, functioning the same as `MOD(N, M)`.
</details>

**Q28. What does `SELECT POWER(2, 3);` yield?**
A) 5
B) 6
C) 8
D) 9

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** POWER(X, Y) returns the value of X raised to the power of Y. 2^3 is 8.
</details>

**Q29. What will `SELECT SQRT(16);` return?**
A) 2
B) 4
C) 8
D) 256

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SQRT() returns the square root of a non-negative number. The square root of 16 is 4.
</details>

**Q30. What values can the `SIGN()` function return in MySQL?**
A) Only 1 or 0
B) -1, 0, or 1
C) TRUE or FALSE
D) Positive integers only

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SIGN() returns -1 for negative numbers, 0 for zero, and 1 for positive numbers.
</details>

**Q31. Which of the following functions generates a random floating-point value v in the range `0 <= v < 1.0`?**
A) RANDOM()
B) RAND()
C) RND()
D) GENERATE_RAND()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** RAND() generates a random floating-point number between 0 (inclusive) and 1 (exclusive).
</details>

**Q32. What is the difference between NOW() and SYSDATE() in MySQL?**
A) There is no difference; they are identical.
B) NOW() returns a string; SYSDATE() returns a date object.
C) NOW() returns the statement start time; SYSDATE() returns the exact execution time.
D) NOW() returns UTC time; SYSDATE() returns local server time.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** NOW() returns a constant time at which the statement began executing, whereas SYSDATE() dynamically evaluates the current time for each row or invocation during execution.
</details>

**Q33. What will `SELECT CURDATE();` return?**
A) The current time only
B) The current date and time
C) The current date without time
D) The current UTC timestamp

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** CURDATE() (or CURRENT_DATE()) returns only the current date in 'YYYY-MM-DD' format.
</details>

**Q34. What does `SELECT CURTIME();` return?**
A) Current date
B) Current date and time
C) Current time only
D) Unix timestamp

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** CURTIME() (or CURRENT_TIME()) returns only the current time in 'HH:MM:SS' format.
</details>

**Q35. What is the output of `SELECT DATE_ADD('2023-01-01', INTERVAL 1 DAY);`?**
A) '2023-01-02'
B) '2023-02-01'
C) '2024-01-01'
D) '2022-12-31'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** DATE_ADD() adds the specified time interval to a date. Adding 1 day to Jan 1 results in Jan 2.
</details>

**Q36. What is the output of `SELECT DATE_SUB('2023-01-02', INTERVAL 1 MONTH);`?**
A) '2022-12-02'
B) '2023-02-02'
C) '2022-01-02'
D) '2023-01-01'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** DATE_SUB() subtracts an interval from a date. Subtracting 1 month from Jan 2, 2023, gives Dec 2, 2022.
</details>

**Q37. How does the `DATEDIFF(expr1, expr2)` function calculate the difference?**
A) expr2 - expr1
B) expr1 - expr2
C) Absolute difference between expr1 and expr2
D) expr1 + expr2

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DATEDIFF() subtracts expr2 from expr1, returning the number of days strictly as `expr1 - expr2`.
</details>

**Q38. What will `SELECT DATEDIFF('2023-01-10', '2023-01-01');` yield?**
A) -9
B) 10
C) 9
D) 8

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** '2023-01-10' minus '2023-01-01' equals 9 days.
</details>

**Q39. What is the purpose of the `TIMESTAMPDIFF()` function?**
A) Returns the difference between two timestamps in days only.
B) Returns the difference between two date/time expressions in a specified unit.
C) Formats a timestamp into a specific string.
D) Calculates the time left until a given timestamp.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** TIMESTAMPDIFF(unit, datetime_expr1, datetime_expr2) calculates the difference between two dates or datetimes in the specified unit (e.g., MONTH, HOUR). Note that it calculates `expr2 - expr1`.
</details>

**Q40. What will `SELECT TIMESTAMPDIFF(MONTH, '2023-01-01', '2023-03-01');` return?**
A) -2
B) 2
C) 60
D) 3

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** TIMESTAMPDIFF calculates expr2 - expr1. From Jan 1 to March 1 is a difference of 2 months.
</details>

**Q41. What does `SELECT DATE_FORMAT('2023-01-15', '%Y');` return?**
A) '23'
B) '2023'
C) '01'
D) '15'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In DATE_FORMAT(), the '%Y' format specifier returns a 4-digit year.
</details>

**Q42. Which format specifier in `DATE_FORMAT()` is used to get the full month name (e.g., 'January')?**
A) %m
B) %M
C) %b
D) %c

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** '%M' returns the full month name. '%m' returns the 2-digit month number, and '%b' returns the abbreviated month name (e.g., 'Jan').
</details>

**Q43. What is the output of `SELECT EXTRACT(YEAR FROM '2023-05-12');`?**
A) 23
B) 05
C) 12
D) 2023

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** EXTRACT() retrieves the specified part (in this case, YEAR) from a date or datetime expression.
</details>

**Q44. What does `SELECT YEAR('2023-05-12');` yield?**
A) 12
B) 05
C) 2023
D) '2023-05'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The YEAR() function extracts the year component from the given date, returning 2023.
</details>

**Q45. What will `SELECT MONTH('2023-05-12');` return?**
A) 5
B) 'May'
C) 12
D) 2023

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The MONTH() function extracts the numeric month component from the date (1 to 12).
</details>

**Q46. What does `SELECT DAY('2023-05-12');` yield?**
A) 5
B) 12
C) 2023
D) 'Friday'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The DAY() function (synonymous with DAYOFMONTH()) extracts the numeric day of the month.
</details>

**Q47. What will `SELECT LAST_DAY('2023-02-15');` return?**
A) '2023-02-28'
B) '2023-02-29'
C) '2023-02-30'
D) '2023-02-31'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** LAST_DAY() returns the last date of the month for a given date. Since 2023 is not a leap year, February ends on the 28th.
</details>

**Q48. What is the output of `SELECT DAYNAME('2023-01-01');`? (Assume Jan 1, 2023 is Sunday)**
A) 1
B) 7
C) 'Sun'
D) 'Sunday'

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** DAYNAME() returns the full textual name of the day of the week for a given date.
</details>

**Q49. What does the `QUARTER()` function return?**
A) A number from 1 to 4 indicating the quarter of the year.
B) A number from 1 to 12 indicating the month.
C) The date of the end of the quarter.
D) The string 'Q1', 'Q2', 'Q3', or 'Q4'.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** QUARTER() evaluates the month of the date and returns 1, 2, 3, or 4 based on which quarter of the year it falls into.
</details>

**Q50. In MySQL, what value does `DAYOFWEEK('2023-01-01')` return if Jan 1, 2023 is a Sunday?**
A) 0
B) 1
C) 7
D) 'Sunday'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DAYOFWEEK() returns the weekday index for a given date according to the ODBC standard, where 1 = Sunday, 2 = Monday, ..., 7 = Saturday.
</details>
