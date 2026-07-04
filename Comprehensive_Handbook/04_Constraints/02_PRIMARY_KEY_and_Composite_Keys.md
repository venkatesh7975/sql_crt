# PRIMARY KEY and Composite Keys

---

## 1. What is a Primary Key?

A **Primary Key** is the most important constraint in a relational database. It is a column (or a set of columns) that **uniquely identifies every single row** in a table.

Because it uniquely identifies rows, the Primary Key engine automatically enforces two rules under the hood:
1.  **`UNIQUE`**: No two rows can have the same Primary Key.
2.  **`NOT NULL`**: A Primary Key can never be empty.

Every table you create should have a Primary Key. Without one, the database has no reliable way to target a specific row for updates or deletions.

### Syntax
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100)
);
```

---

## 2. Natural vs Surrogate Keys

When designing a database, you must choose what column to use as your Primary Key. There are two philosophies:

### Natural Keys
A Natural Key is a column that uniquely identifies the row using real-world business data.
*   **Examples:** Social Security Number, Vehicle VIN Number, ISBN of a book, Email Address.
*   **Pros:** Requires one less column in the database.
*   **Cons (The Danger):** Business data changes. If a user changes their email address, and you used `email` as the Primary Key, you have to execute a catastrophic cascade of updates across every other table that references that email. *Never use Natural Keys for user-editable data.*

### Surrogate Keys (Best Practice)
A Surrogate Key is a meaningless, computer-generated identifier that has no connection to the real world.
*   **Examples:** An `AUTO_INCREMENT` integer (`id = 1`), or a UUID (`id = 'f47ac10b-58cc-4372-a567-0e02b2c3d479'`).
*   **Pros:** They never change. Even if a user changes their name, email, and address, their backend `id` remains `1`. This provides perfect stability for the database.
*   *Verdict:* **Almost always use Surrogate Keys (`id INT AUTO_INCREMENT`) in modern applications.**

---

## 3. Composite Keys

What if a single column isn't enough to uniquely identify a row?
A **Composite Key** is a Primary Key made up of **two or more columns combined together**.

### The Junction Table Scenario
Composite Keys are most commonly used in "Many-to-Many" junction tables.
Imagine a university database with a `students` table and a `classes` table. A student can take many classes, and a class can have many students. To link them, we build an `enrollments` table.

In the `enrollments` table, a student might appear many times, and a class might appear many times. Therefore, neither `student_id` nor `class_id` can be the Primary Key on their own.

However, a specific student can only enroll in a specific class *once*. Therefore, the **combination** of `student_id` and `class_id` is unique!

### Creating a Composite Key
To create a Composite Key, you cannot put the `PRIMARY KEY` keyword next to the columns. You must declare it at the bottom of the `CREATE TABLE` statement.

```sql
CREATE TABLE enrollments (
    student_id INT,
    class_id INT,
    enrollment_date DATE,
    
    -- Defining the Composite Key
    PRIMARY KEY (student_id, class_id)
);
```
In this table, the database will accept `(1, 101)` and `(1, 102)`. But if you try to insert `(1, 101)` a second time, the Composite Key constraint will reject it, preventing duplicate enrollments.

---

## 4. Interview Tips
*   **Multiple Primary Keys:** "Can a table have multiple Primary Keys?"
    *   **Answer:** "No. A table can only have exactly ONE Primary Key constraint. However, that single constraint can be a *Composite Key* comprised of multiple columns."
*   **Clustered Indexes:** The Primary Key does more than just enforce uniqueness; in MySQL (InnoDB), it dictates the physical sorting of the data on the hard drive. This is called a **Clustered Index**, which makes querying by ID astronomically fast. (We will cover this deeply in the Indexes section).
