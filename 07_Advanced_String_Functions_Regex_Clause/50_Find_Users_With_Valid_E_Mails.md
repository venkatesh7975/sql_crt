# Problem 50 – Find Users With Valid E-Mails

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Regular Expressions (`REGEXP`)

---

## 3. Pattern
Regex Pattern Matching

---

## 4. Problem Statement
Write a SQL query to find the users who have **valid emails**.
A valid e-mail has a prefix name and a domain where:
*   The **prefix name** is a string that may contain letters (upper or lower case), digits, underscore `_`, period `.`, and/or dash `-`. The prefix name **must start with a letter**.
*   The **domain** is `@leetcode.com`.

---

## 5. Tables

Table: Users

| Column  | Type    |
| ------- | ------- |
| user_id | INT     |
| name    | VARCHAR |
| mail    | VARCHAR |

* `user_id` is the primary key.
* This table contains information of the users signed up in a website. Some e-mails are invalid.

---

## 6. Sample Input

Users table:

| user_id | name      | mail                    |
| ------- | --------- | ----------------------- |
| 1       | Winston   | winston@leetcode.com    |
| 2       | Jonathan  | jonathanisgreat         |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
| 5       | Marwan    | quarz#2020@leetcode.com |
| 6       | David     | david69@gmail.com       |
| 7       | Shapiro   | .shapo@leetcode.com     |

---

## 7. Expected Output

| user_id | name      | mail                    |
| ------- | --------- | ----------------------- |
| 1       | Winston   | winston@leetcode.com    |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |

*(Winston: Valid)*
*(Jonathan: Missing domain. Invalid)*
*(Annabelle: Contains valid dash. Valid)*
*(Sally: Contains valid period. Valid)*
*(Marwan: Contains invalid hashtag `#`. Invalid)*
*(David: Wrong domain. Invalid)*
*(Shapiro: Starts with a period instead of a letter. Invalid)*

---

## 8. Understanding the Question
What information is being asked? The exact rows of users who have perfectly formatted emails.
What columns are important? `mail`.
What conditions matter? 
1. Starts with `[a-zA-Z]`.
2. Middle can be any number of `[a-zA-Z0-9_.-]`.
3. Ends strictly with `@leetcode.com`.
What should be returned? All columns (`*`).

---

## 9. Thinking Process
1. Standard `LIKE` statements cannot solve this. `LIKE '%@leetcode.com'` does not enforce the "starts with a letter" or the "no invalid special characters" rules. We MUST use Regex.
2. Let's build the regular expression step by step.
3. **Start of string:** `^`
4. **First character must be a letter:** `[a-zA-Z]`
5. **Remaining prefix characters:** May contain letters, digits, underscores, periods, or dashes. 
   * Character class: `[a-zA-Z0-9_.-]`
   * Quantity: Zero or more times. `*`
   * Combined: `[a-zA-Z0-9_.-]*`
6. **The Domain:** Must be exactly `@leetcode.com`.
   * Because the period `.` is a special regex character (meaning "any character"), we must escape it with a double backslash in MySQL strings: `\\.`
   * Domain: `@leetcode\\.com`
7. **End of string:** `$`
8. Assemble the full regex string: `'^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$'`
9. Apply it in the query: `WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$'`

---

## 10. Approach 1 (Optimal)
Regular Expressions (REGEXP)

Use MySQL's built-in `REGEXP` engine to strictly enforce the complex string validation rules.

---

## 11. SQL Solution

```sql
-- Find strictly formatted valid emails using Regex
SELECT 
    * 
FROM 
    Users
WHERE 
    mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$';
```

---

## 12. Step-by-Step Dry Run
1. **winston@leetcode.com**: 
   * `^` (Start) -> `[a-zA-Z]` ('w') -> `[...]*` ('inston') -> `@leetcode\.com$` (Match). **TRUE.**
2. **jonathanisgreat**: 
   * Fails the `@leetcode\.com$` check. **FALSE.**
3. **quarz#2020@leetcode.com**: 
   * `[a-zA-Z]` ('q') -> `[...]*` ('uarz'). Hits the `#`. `#` is not in the allowed character class. **FALSE.**
4. **.shapo@leetcode.com**: 
   * Evaluates first character against `[a-zA-Z]`. `.` is not a letter. **FALSE.**

---

## 13. SQL Execution Order
1. **FROM Users:** Loads the table.
2. **WHERE REGEXP:** Feeds every `mail` string through the regex engine. Drops failures.
3. **SELECT *:** Returns the surviving rows.

---

## 14. Query Breakdown
* **`^` and `$`:** Absolutely crucial. If you omit `^`, a string like `123alice@leetcode.com` would pass because the regex engine would just ignore the `123` and say "Well, the `alice` part matches!". `^` and `$` force the regex to evaluate the *entire* string from the very first character to the very last.
* **`\\.`:** Escaping the period. If you write `@leetcode.com`, a user with the email `@leetcodeXcom` would pass, because a raw period means "match any single character". In MySQL, you escape regex with double backslashes.

---

## 15. Why This Solution Works
Regex is the universal standard for email validation across all programming languages. MySQL's `REGEXP` operator allows us to bring that power directly into the database query.

---

## 16. Alternative Solution
N/A. Attempting to write this with standard `LIKE`, `SUBSTRING`, and `INSTR` would require dozens of lines of nested logic and is highly discouraged.

---

## 17. Time Complexity
**O(N * M)** where N is the number of users and M is the average length of the email string. The regex engine evaluates each string. It cannot use standard B-Tree indexes, requiring a full table scan.

---

## 18. Common Mistakes
* **Forgetting `^` and `$`:** As explained, this allows invalid prefixes and suffixes to slip through.
* **Failing to escape the period:** `@leetcode.com` matches `@leetcodeXcom`.
* **Escaping with a single backslash:** `\@leetcode\.com`. MySQL string literals require double backslashes for regex escapes (`\\.`).
* **Putting `-` in the middle of a character class:** `[a-zA-Z0-9-. _]`. In regex, a dash in the middle of a bracket means "Range" (like `A-Z`). If you want to include a literal dash, it must be the very first or very last character in the bracket: `[a-zA-Z0-9_.-]`.

---

## 19. Edge Cases
* **Capital letters in the email:** Handled correctly because we used `a-zA-Z` instead of just `a-z`.
* **Shortest possible valid email:** `a@leetcode.com` passes perfectly (The `*` quantifier allows zero occurrences of the middle characters).

---

## 20. Interview Tips
* If you memorize only one Regex pattern for SQL interviews, memorize this one. Email validation is a classic question.
* Pointing out the "Range Trap" regarding where to place the `-` dash inside the character brackets proves you actually understand Regex and didn't just copy-paste from StackOverflow.

---

## 21. Similar LeetCode Problems
* 1527. Patients With a Condition (Regex word boundaries)

---

## 22. Key Takeaways
* Use `REGEXP` in MySQL for complex string validations.
* `^` anchors the start, `$` anchors the end.
* `[...]` defines an allowed list of characters. `*` means zero or more.
* Always escape special regex characters (like periods) with `\\` in MySQL.
