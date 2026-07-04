# MySQL 8.0 Multiple Choice Questions: String and Math Functions (Part 2)

**Q51. What will `SELECT LPAD('SQL', 5, '*');` return?**
A) SQL**
B) **SQL
C) *SQL*
D) SQL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LPAD(str, len, padstr) pads the string on the left side with the given pad string until it reaches the specified length.
</details>

**Q52. What will `SELECT RPAD('SQL', 5, '*');` return?**
A) SQL**
B) **SQL
C) *SQL*
D) SQL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** RPAD(str, len, padstr) pads the string on the right side until it reaches the specified length.
</details>

**Q53. What is the output of `SELECT REVERSE('abc');`?**
A) abc
B) bca
C) cba
D) c b a

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The REVERSE() function reverses all the characters in a string.
</details>

**Q54. What does `SELECT REPEAT('a', 3);` return?**
A) aaa
B) a3
C) a a a
D) 3a

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The REPEAT() function repeats a string a specified number of times.
</details>

**Q55. What does the `SPACE(5)` function return?**
A) An empty string
B) A string consisting of 5 space characters
C) The number 5
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SPACE(N) returns a string consisting of N space characters.
</details>

**Q56. What will `SELECT SUBSTRING_INDEX('a.b.c', '.', 2);` return?**
A) a.b
B) b.c
C) a
D) c

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** SUBSTRING_INDEX(str, delim, count) returns the substring from string 'str' before 'count' occurrences of the delimiter. 
</details>

**Q57. What is the output of `SELECT SUBSTRING_INDEX('a.b.c', '.', -2);`?**
A) a.b
B) b.c
C) c
D) a

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If the count is negative, SUBSTRING_INDEX counts from the right and returns everything to the right of the final delimiter found.
</details>

**Q58. What will `SELECT ASCII('A');` return?**
A) 'a'
B) 65
C) 97
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The ASCII() function returns the numeric ASCII value of the first character of the string.
</details>

**Q59. What does `SELECT CHAR(65);` return?**
A) 'A'
B) 'a'
C) 65
D) '6'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The CHAR() function returns the character representing the given ASCII values.
</details>

**Q60. What is the output of `SELECT FIND_IN_SET('b', 'a,b,c');`?**
A) 1
B) 2
C) 3
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FIND_IN_SET(str, strlist) returns the 1-based index of the string within a comma-separated list.
</details>

**Q61. What does `SELECT FIELD('b', 'a', 'b', 'c');` yield?**
A) 1
B) 2
C) 3
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FIELD(str, str1, str2, ...) returns the index (1-based) of 'str' within the list of subsequent strings.
</details>

**Q62. What does `SELECT INSERT('Quadratic', 3, 4, 'What');` return?**
A) QuWhattic
B) QuaWhattic
C) QuWhatratic
D) QuWhat

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** INSERT(str, pos, len, newstr) replaces the substring starting at 'pos' (3) and 'len' (4) characters long with the 'newstr' ('What').
</details>

**Q63. What will `SELECT FORMAT(1234.567, 2);` return?**
A) 1234.57
B) '1,234.57'
C) 1234.56
D) '1,234.56'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FORMAT() formats a number with grouping separators (like commas) and rounds to the specified decimals, returning it as a string.
</details>

**Q64. What is the output of `SELECT EXP(1);`?**
A) 1
B) The base of natural logarithms (e)
C) 10
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** EXP(X) returns the value of e (the base of natural logarithms) raised to the power of X.
</details>

**Q65. What does the `LOG(100)` function compute in MySQL by default?**
A) The base-10 logarithm of 100
B) The natural logarithm (base e) of 100
C) The base-2 logarithm of 100
D) 100 squared

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, LOG() without a specified base returns the natural logarithm. For base-10, you must use LOG10().
</details>

**Q66. What will `SELECT LOG10(100);` return?**
A) 10
B) 2
C) 4.605
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LOG10() computes the base-10 logarithm. 10^2 = 100, so it returns 2.
</details>

**Q67. What does `SELECT PI();` return in MySQL?**
A) 3.14
B) 3.141593
C) 3.141592653589793
D) 3

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** PI() returns the value of pi. The default number of decimal places displayed is 6, although internally it is kept with double-precision.
</details>

**Q68. What function is used to convert 180 degrees into radians?**
A) TO_RADIAN(180)
B) RAD(180)
C) RADIANS(180)
D) DEG2RAD(180)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** RADIANS(X) converts an argument from degrees to radians.
</details>

**Q69. Which function converts radians back into degrees?**
A) DEGREES()
B) RAD2DEG()
C) TO_DEGREES()
D) ANGLE()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** DEGREES(X) converts an argument from radians to degrees.
</details>

**Q70. Which of the following correctly generates a random integer R in the range 5 <= R < 15?**
A) SELECT FLOOR(5 + (RAND() * 10));
B) SELECT CEIL(5 + (RAND() * 15));
C) SELECT FLOOR(RAND() * 15) + 5;
D) Both A and C are correct.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The general formula for a random integer in range [MIN, MAX) is FLOOR(MIN + (RAND() * (MAX - MIN))). Here MIN=5 and MAX=15, so MAX - MIN = 10.
</details>

**Q71. What will `SELECT ADDDATE('2023-01-01', 5);` return?**
A) '2023-01-06'
B) '2023-06-01'
C) '2028-01-01'
D) An error

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** When invoked with a single numeric integer as the second argument, ADDDATE() treats it as days to add to the date.
</details>

**Q72. What does `SELECT MAKEDATE(2023, 32);` yield?**
A) '2023-12-02'
B) '2023-02-01'
C) '2023-03-02'
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MAKEDATE(year, dayofyear) creates a date based on the year and the day of the year. The 32nd day of 2023 is February 1st.
</details>

**Q73. What is the output of `SELECT MAKETIME(12, 15, 30);`?**
A) '12-15-30'
B) '12:15:30'
C) 121530
D) A datetime object

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MAKETIME(hour, minute, second) creates a time value and formats it as 'HH:MM:SS'.
</details>

**Q74. What will `SELECT SEC_TO_TIME(3600);` return?**
A) '00:36:00'
B) '01:00:00'
C) '00:00:36'
D) '3600'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SEC_TO_TIME(seconds) converts a numeric value in seconds to a 'HH:MM:SS' formatted time string. 3600 seconds is 1 hour.
</details>

**Q75. What does `SELECT TIME_TO_SEC('01:00:00');` yield?**
A) 60
B) 100
C) 3600
D) 1

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** TIME_TO_SEC(time) converts a time value to its equivalent total in seconds.
</details>

**Q76. What does the `UNIX_TIMESTAMP()` function return when called without arguments?**
A) The current date
B) The current time in seconds since the '1970-01-01 00:00:00' UTC epoch
C) A random timestamp
D) The server's uptime

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** UNIX_TIMESTAMP() without arguments returns an unsigned integer representing the seconds since the Epoch.
</details>

**Q77. What will `SELECT FROM_UNIXTIME(0);` return?**
A) The current local datetime
B) NULL
C) '1970-01-01 00:00:00' (adjusted to the local time zone)
D) An error

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** FROM_UNIXTIME() converts a UNIX timestamp back to a standard datetime format in the current session's time zone.
</details>

**Q78. What does `SELECT ADDTIME('01:00:00', '01:30:00');` yield?**
A) '02:30:00'
B) '00:30:00'
C) '01:30:00'
D) '02:00:00'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** ADDTIME(expr1, expr2) adds expr2 (which can be a time interval) to expr1 and returns the result.
</details>

**Q79. What will `SELECT CONVERT_TZ('2023-01-01 12:00:00', '+00:00', '+05:30');` return?**
A) '2023-01-01 12:00:00'
B) '2023-01-01 17:30:00'
C) '2023-01-01 06:30:00'
D) '2023-01-01 05:30:00'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CONVERT_TZ(dt, from_tz, to_tz) converts a datetime value from one time zone to another. Adding 5 hours and 30 minutes to 12:00:00 gives 17:30:00.
</details>

**Q80. What is the result of `SELECT DAYOFYEAR('2023-02-01');`?**
A) 1
B) 2
C) 31
D) 32

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** DAYOFYEAR() returns a number between 1 and 366. January has 31 days, plus 1 day in February equals the 32nd day.
</details>

**Q81. What does `SELECT WEEKDAY('2023-01-02');` return if Jan 2, 2023 is a Monday?**
A) 0
B) 1
C) 2
D) 7

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** WEEKDAY() returns the weekday index starting at 0 for Monday, 1 for Tuesday, ..., 6 for Sunday.
</details>

**Q82. What will `SELECT YEARWEEK('2023-01-01');` return?**
A) 202301
B) 2023
C) 01
D) 202252 (or similar, depending on the mode)

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** YEARWEEK() returns the year and week. Since Jan 1, 2023 was a Sunday and likely part of the last week of 2022 under default modes, it returns 202252.
</details>

**Q83. What is the output of `SELECT PERIOD_ADD(202301, 2);`?**
A) 202303
B) 202501
C) 202301
D) 20232

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** PERIOD_ADD(P, N) adds N months to period P (formatted as YYYYMM or YYMM) and returns a value in YYYYMM format.
</details>

**Q84. What does `SELECT PERIOD_DIFF(202303, 202301);` return?**
A) 2
B) -2
C) 200
D) 0

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** PERIOD_DIFF(P1, P2) returns the number of months between periods P1 and P2 as (P1 - P2).
</details>

**Q85. What will `SELECT TIMEDIFF('12:00:00', '10:00:00');` yield?**
A) '02:00:00'
B) 2
C) '10:00:00'
D) '22:00:00'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** TIMEDIFF(expr1, expr2) returns the time difference expressed as a time value (expr1 - expr2).
</details>

**Q86. What is the output of `SELECT EXTRACT(YEAR_MONTH FROM '2023-05-12');`?**
A) '2023-05'
B) 202305
C) 2023
D) 5

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** EXTRACT(YEAR_MONTH FROM date) extracts the year and month components as a single numeric value in the format YYYYMM.
</details>

**Q87. What does `SELECT MAKE_SET(1 | 4, 'a', 'b', 'c', 'd');` return?**
A) 'a,b,c'
B) 'a,d'
C) 'a,c'
D) 'a,c,d'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MAKE_SET(bits, str1, str2, ...) returns a comma-separated string containing the strings corresponding to the bits set in the 'bits' argument. 1 | 4 is 5 (binary 0101), so the 1st and 3rd strings ('a' and 'c') are chosen.
</details>

**Q88. What will `SELECT TIMESTAMPADD(MINUTE, 30, '2023-01-01 12:00:00');` return?**
A) '2023-01-01 12:30:00'
B) '2023-01-01 12:00:30'
C) '2023-01-02 12:00:00'
D) An error

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** TIMESTAMPADD(unit, interval, datetime_expr) adds the integer interval of the specified unit (minutes) to the datetime expression.
</details>

**Q89. How does MySQL round exactly halfway values (e.g., 2.5) in the `ROUND()` function?**
A) To the nearest even number
B) Always towards zero
C) Away from zero (e.g., 2.5 becomes 3, -2.5 becomes -3)
D) Downwards (e.g., 2.5 becomes 2)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** For exact-value numbers, ROUND() uses "round half away from zero" or "round half up" logic.
</details>

**Q90. What happens if you pass a negative number as the `length` argument to `SUBSTRING()`?**
A) It extracts from right to left
B) It throws a syntax error
C) It returns an empty string
D) It ignores the negative sign

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If the length argument in SUBSTRING() is less than 1 (zero or negative), the function returns an empty string.
</details>

**Q91. What will `SELECT DATEDIFF('2023-01-02 12:00:00', '2023-01-01 23:00:00');` yield?**
A) 0
B) 1
C) 13
D) 24

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DATEDIFF() only calculates the difference based on the date parts. The time parts are ignored.
</details>

**Q92. What is the output of `SELECT UPPER(LEFT('mysql', 1));`?**
A) mysql
B) m
C) M
D) MYSQL

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Combining functions: LEFT('mysql', 1) gets 'm', and UPPER() converts it to 'M'.
</details>

**Q93. Which function extracts the sign of the argument (-1, 0, or 1)?**
A) VALUE()
B) POLARITY()
C) SIGN()
D) ABS()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** SIGN() returns -1 if the number is negative, 0 if it is zero, and 1 if the number is positive.
</details>

**Q94. What will `SELECT CHAR_LENGTH('💡');` return if the database is configured with utf8mb4?**
A) 4
B) 1
C) 2
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CHAR_LENGTH() counts characters. Even though an emoji takes 4 bytes in utf8mb4, it is still only 1 character.
</details>

**Q95. What will `SELECT LENGTH('💡');` return in a utf8mb4 setup?**
A) 1
B) 2
C) 3
D) 4

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** LENGTH() counts bytes. A 4-byte emoji like '💡' will return a length of 4.
</details>

**Q96. What does `SELECT STR_TO_DATE('31-12-2023', '%d-%m-%Y');` return?**
A) '2023-12-31'
B) '31-12-2023'
C) NULL
D) A syntax error

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** STR_TO_DATE() converts a formatted string into a standard MySQL date ('YYYY-MM-DD').
</details>

**Q97. What does the `MOD(N, M)` function return when M is 0?**
A) 0
B) NULL
C) N
D) Throws a division by zero error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, MOD(N, 0) returns NULL rather than throwing a division by zero exception.
</details>

**Q98. What will `SELECT CONCAT_WS(',', 'A', NULL, 'B', '');` return?**
A) 'A,,B,'
B) 'A,NULL,B,'
C) 'A,B,'
D) 'A,B'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** CONCAT_WS() ignores NULL values completely but includes empty strings. So it joins 'A', 'B', and '' with commas resulting in 'A,B,'.
</details>

**Q99. Which date function returns the name of the month for a given date?**
A) MONTH_NAME()
B) NAME_OF_MONTH()
C) MONTHNAME()
D) GET_MONTH()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MONTHNAME() extracts and returns the full string name of the month (e.g., 'January').
</details>

**Q100. What is the outcome of `SELECT TRUNCATE(10.555, 0);`?**
A) 10.5
B) 11
C) 10
D) 10.0

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** TRUNCATE(X, 0) cuts off all decimal places without rounding, returning the integer part 10.
</details>
