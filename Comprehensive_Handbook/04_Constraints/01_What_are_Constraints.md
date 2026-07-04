# SQL Constraints (Basic)

---

## 1. What are Constraints?

A relational database is only useful if the data inside it is clean and reliable. If you have an e-commerce database, and the "Price" column contains the word `"Banana"`, or a user registers without providing an email address, your application will crash.

**Constraints** are strict rules applied to columns during table creation (or via `ALTER TABLE`). If any `INSERT` or `UPDATE` operation attempts to violate a constraint, the database engine will outright reject the query and throw an error. 

Constraints are the ultimate defenders of **Data Integrity**.

---

## 2. Basic Constraints

### NOT NULL
By default, any column in SQL can accept `NULL` (empty) values. The `NOT NULL` constraint forbids this.
*   **Use Case:** Fields that are absolutely mandatory for the application to function (e.g., passwords, email addresses).
```sql
CREATE TABLE users (
    id INT,
    username VARCHAR(50) NOT NULL
);
```

### DEFAULT
If a user inserts a row but forgets to provide a value for a specific column, the `DEFAULT` constraint automatically fills in a pre-specified value instead of leaving it `NULL`.
*   **Use Case:** Setting default account statuses, timestamps, or boolean flags.
```sql
CREATE TABLE users (
    id INT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### UNIQUE
Ensures that all values in a column are entirely different from one another. No duplicates allowed.
*   **Use Case:** Usernames, Email addresses, Social Security Numbers, Product SKUs.
*   *Note:* A column can be `UNIQUE` and still allow multiple `NULL` values (because `NULL` is not considered equal to another `NULL`).
```sql
CREATE TABLE users (
    id INT,
    email VARCHAR(100) UNIQUE
);
```

### CHECK
The `CHECK` constraint allows you to write custom logical conditions that a value must pass before it is allowed into the table. 
*   **Use Case:** Ensuring age is over 18, ensuring prices are not negative, ensuring strings meet a certain length.
```sql
CREATE TABLE products (
    id INT,
    price DECIMAL(10, 2) CHECK (price >= 0),
    discount_percentage INT CHECK (discount_percentage BETWEEN 0 AND 100)
);
```
*(Note: Older versions of MySQL parsed the CHECK constraint but silently ignored it. In modern MySQL 8.0+, CHECK constraints are fully enforced).*

---

## 3. AUTO_INCREMENT (MySQL Specific)

While standard SQL uses sequences, MySQL provides the incredibly convenient `AUTO_INCREMENT` constraint. It automatically generates a unique sequential integer (1, 2, 3...) every time a new row is inserted.

*   **Rule 1:** There can only be one `AUTO_INCREMENT` column per table.
*   **Rule 2:** The column MUST be defined as a key (usually the `PRIMARY KEY`).

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

-- We do not provide an ID. MySQL generates '1' automatically.
INSERT INTO users (name) VALUES ('Alice'); 
-- MySQL generates '2' automatically.
INSERT INTO users (name) VALUES ('Bob');   
```

---

## 4. Interview Tips
*   **UNIQUE vs PRIMARY KEY:** A classic interview question. Both enforce uniqueness. However, a table can have many `UNIQUE` constraints, but only one `PRIMARY KEY`. Furthermore, `UNIQUE` allows `NULL` values, whereas `PRIMARY KEY` strictly enforces `NOT NULL`.
*   **Business Logic in the DB:** Interviewers might ask, "Should we validate that an age is >= 18 in the backend application code (Python/Java), or in the database using a `CHECK` constraint?"
    *   **Answer:** "Both. The application should catch it first to provide a friendly UI error to the user. But the database `CHECK` constraint is the final line of defense to prevent bad data if a developer accidentally bypasses the application logic or writes a rogue script."
