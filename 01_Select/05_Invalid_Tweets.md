# Problem 05 – Invalid Tweets

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* WHERE
* String Functions (`LENGTH` / `CHAR_LENGTH`)

---

## 3. Pattern
Filtering by String Length

---

## 4. Problem Statement
We need to find the IDs of all invalid tweets. A tweet is considered invalid if it contains strictly more than 15 characters.

---

## 5. Tables

Table: Tweets

| Column   | Type    |
| -------- | ------- |
| tweet_id | INT     |
| content  | VARCHAR |

* `tweet_id` is the primary key for this table.
* `content` contains the text of the tweet.

---

## 6. Sample Input

Tweets table:

| tweet_id | content                          |
| -------- | -------------------------------- |
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |

---

## 7. Expected Output

| tweet_id |
| -------- |
| 2        |

---

## 8. Understanding the Question
What information is being asked? The IDs of specific tweets.
What columns are important? `tweet_id` and `content`.
What conditions matter? The number of characters in `content` must be > 15.
What should be returned? Just the `tweet_id`.

---

## 9. Thinking Process
1. I need to output `tweet_id` from the `Tweets` table.
2. I need to filter the rows based on the length of the string in the `content` column.
3. In MySQL, to get the number of characters in a string, I can use the `CHAR_LENGTH()` function. 
4. The condition is strictly greater than 15, so I will write `CHAR_LENGTH(content) > 15`.
5. I'll place this condition inside the `WHERE` clause.

---

## 10. Approach 1 (Optimal)
Filtering with String Functions

Calculate the length of the tweet content for each row, and only keep rows where that length exceeds 15.

---

## 11. SQL Solution

```sql
-- Retrieve the tweet_id where the tweet length is greater than 15
SELECT 
    tweet_id
FROM 
    Tweets
WHERE 
    CHAR_LENGTH(content) > 15;
```

---

## 12. Step-by-Step Dry Run
1. **Row 1:** content = "Vote for Biden"
   * Count characters: V(1) o(2) t(3) e(4)  (5) f(6) o(7) r(8)  (9) B(10) i(11) d(12) e(13) n(14). Total = 14.
   * Is 14 > 15? False. Ignore.
2. **Row 2:** content = "Let us make America great again!"
   * Count characters: well over 30 characters.
   * Is 32 > 15? True. Keep.
   
Result: tweet_id 2.

---

## 13. SQL Execution Order
1. **FROM:** Points to the `Tweets` table.
2. **WHERE:** Evaluates the `CHAR_LENGTH(content)` function for every row. If the result is > 15, the row is kept.
3. **SELECT:** Grabs the `tweet_id` for the surviving rows.

---

## 14. Query Breakdown
* **CHAR_LENGTH(content):** A built-in MySQL function that returns the number of *characters* in a string.
* **> 15:** Strictly greater than operator.

---

## 15. Why This Solution Works
It directly answers the prompt using the most appropriate built-in string function for character counting.

---

## 16. Alternative Solution
Using `LENGTH()`

```sql
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;
```
* **Advantages:** Shorter to type. In many basic ASCII cases, it yields the exact same result.
* **Disadvantages:** **Very dangerous in the real world.** `LENGTH()` returns the length of a string in *bytes*, while `CHAR_LENGTH()` returns the length in *characters*. If a tweet contains emojis or multi-byte characters (like Chinese or Japanese text, or an emoji like 😊), `LENGTH(😊)` might return 4 (bytes), while `CHAR_LENGTH(😊)` returns 1 (character). Since a tweet's limit is based on *characters*, `CHAR_LENGTH()` is the only fully correct answer. LeetCode test cases for this specific problem might pass with `LENGTH()`, but an interviewer will dock points for it.

---

## 17. Time Complexity
**O(N)** where N is the number of rows. The database must compute the length of the string for every row in the table (a full table scan).

---

## 18. Common Mistakes
* **Using `LENGTH()` instead of `CHAR_LENGTH()`:** As explained above, this fails on multi-byte characters.
* **Using `>= 15`:** The prompt says "strictly greater than 15", which means `> 15`. A tweet with exactly 15 characters is valid.

---

## 19. Edge Cases
* **Exactly 15 characters:** Correctly ignored.
* **Empty string / NULL:** If a tweet is empty `""`, length is 0 (valid). If a tweet is `NULL`, `CHAR_LENGTH(NULL)` is `NULL`, which evaluates to UNKNOWN, so it is safely ignored.
* **Tweets with emojis:** `CHAR_LENGTH` handles these correctly as single characters.

---

## 20. Interview Tips
* **Crucial Tip:** If asked this in an interview, *always* explain the difference between `LENGTH()` (bytes) and `CHAR_LENGTH()` (characters). This demonstrates deep knowledge of how databases store text (UTF-8 encoding) and will instantly impress an interviewer.

---

## 21. Similar LeetCode Problems
* 1873. Calculate Special Bonus (also uses string manipulation / conditionals)
* 1527. Patients With a Condition (uses string matching)

---

## 22. Key Takeaways
* Built-in functions can be used directly inside a `WHERE` clause.
* Use `CHAR_LENGTH()` when you want the number of characters in a string.
* Avoid `LENGTH()` for user-generated text, as it counts bytes and breaks on emojis and foreign languages.
