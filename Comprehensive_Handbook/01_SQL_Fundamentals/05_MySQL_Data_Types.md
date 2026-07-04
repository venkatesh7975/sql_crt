# MySQL Data Types

---

## 1. Why Data Types Matter

When you create a table, you must explicitly declare what kind of data each column will hold. This is completely different from dynamically typed languages like Python or JavaScript.

**Why strictly type data?**
1.  **Storage Efficiency:** A boolean (`TRUE`/`FALSE`) takes up 1 byte. A long text article takes up megabytes. Specifying the exact type prevents massive database bloat.
2.  **Data Integrity:** If a column is defined as an `INT` (Integer), the database will outright reject any attempt to insert the word `"Apple"`. This protects your application from catastrophic bugs.
3.  **Query Performance:** The engine can search and sort integers drastically faster than it can sort text strings.

---

## 2. Numeric Types

### Integers (Whole Numbers)
*   **`TINYINT`**: (-128 to 127). Size: 1 byte.
    *   *Best for:* Booleans (MySQL translates `BOOLEAN` to `TINYINT(1)` behind the scenes), status flags (0, 1, 2).
*   **`SMALLINT`**: (-32,768 to 32,767). Size: 2 bytes.
*   **`INT`**: (-2 Billion to 2 Billion). Size: 4 bytes.
    *   *Best for:* Standard Primary Keys (`user_id`), standard counters.
*   **`BIGINT`**: (Massive). Size: 8 bytes.
    *   *Best for:* Global ID generation (like Twitter Snowflakes), massive financial ledgers.

*Tip: You can use the `UNSIGNED` attribute to forbid negative numbers, which doubles the maximum positive limit (e.g., `INT UNSIGNED` goes up to 4 Billion).*

### Decimals (Fractions)
*   **`DECIMAL(M, D)`**: Exact precision. Stores numbers as strings to prevent floating-point rounding errors. 
    *   `M` = Total digits, `D` = Digits after the decimal.
    *   *Best for:* **Money!** Always use `DECIMAL(10, 2)` for currency. Never use FLOAT for money!
*   **`FLOAT` / `DOUBLE`**: Approximate precision. Uses standard floating-point math. Faster, but suffers from rounding errors (e.g., `1.99999999998`).
    *   *Best for:* Scientific measurements, GPS coordinates.

---

## 3. String Types (Text)

### Fixed Length vs Variable Length
*   **`CHAR(N)`**: Fixed length string. If you specify `CHAR(10)` and insert `"hi"`, it pads the rest with 8 spaces.
    *   *Best for:* US State Abbreviations (`CHAR(2)` -> 'NY', 'CA'), MD5 Hashes (`CHAR(32)`).
    *   *Pro:* Slightly faster read speeds because every row is the exact same size on the hard drive.
*   **`VARCHAR(N)`**: Variable length string. If you specify `VARCHAR(255)` and insert `"hi"`, it only uses 2 bytes (plus a tiny header).
    *   *Best for:* Names, emails, passwords, URLs. This is the most common text type.

### Large Text
*   **`TEXT`**: Used for massive strings up to 64KB.
*   **`LONGTEXT`**: Used for gigabytes of text.
    *   *Best for:* Blog posts, HTML content, large JSON payloads.
    *   *Warning:* You cannot easily index or sort a `TEXT` column.

---

## 4. Date and Time Types

*   **`DATE`**: YYYY-MM-DD. (e.g., '2023-12-25').
*   **`TIME`**: HH:MM:SS. (e.g., '14:30:00').
*   **`DATETIME`**: YYYY-MM-DD HH:MM:SS. 
    *   *Best for:* Static dates like `user_date_of_birth`. It does NOT care about timezones.
*   **`TIMESTAMP`**: Similar to DATETIME, but **Timezone Aware**. It automatically converts the time to UTC for storage, and converts it back to your local timezone when you query it.
    *   *Best for:* `created_at` and `updated_at` system columns.

---

## 5. Specialty Types

*   **`ENUM('value1', 'value2')`**: Restricts the column to exactly one of the predefined strings.
    *   *Example:* `status ENUM('pending', 'shipped', 'delivered')`.
    *   *Pro:* Highly compressed (stores as an integer behind the scenes).
    *   *Con:* Modifying the ENUM list later can lock the table in massive databases.
*   **`JSON`**: (Introduced in MySQL 5.7+). Validates that the inserted text is valid JSON, and allows you to query inside the JSON object natively!
    *   *Example:* `SELECT data->'$.preferences.theme' FROM users;`
*   **`BLOB`**: Binary Large Object. Used for storing raw binary data (images, PDFs, compiled code).
    *   *Best Practice:* **Do not store files in a database!** Store the file in AWS S3 and store the *URL string* in the database as a `VARCHAR`.

---

## 6. Interview Tips
*   **The Currency Question:** "How would you store currency in a database?"
    *   **Wrong Answer:** `FLOAT` or `DOUBLE`. (Floating point math causes rounding errors that anger accountants).
    *   **Right Answer:** `DECIMAL(10,2)` for exact precision, or `INT` storing the value in *cents* (e.g., $10.00 is stored as 1000).
*   **CHAR vs VARCHAR:** Be ready to explain the tradeoff. `CHAR` is faster but wastes space for variable data. `VARCHAR` saves space but is slightly slower to read due to length calculation headers.
*   **BLOBs:** If an interviewer asks if you should store profile pictures as `BLOB`s, vehemently say NO. Explain that it bloats the database size, destroys backup/restore times, and bypasses CDN (Content Delivery Network) caching. Store images in object storage (S3) and save the URL.
