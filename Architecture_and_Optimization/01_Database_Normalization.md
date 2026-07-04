# Database Normalization Guide

Database normalization is the process of organizing data in a relational database to reduce data redundancy and improve data integrity. It involves dividing large tables into smaller, less redundant tables and defining relationships between them.

The process is generally divided into several "Normal Forms" (NF). In the industry, reaching the **3rd Normal Form (3NF)** is considered the standard for most transactional databases (OLTP).

---

## 1. First Normal Form (1NF)

**The Rule:** A table is in 1NF if every column contains atomic (indivisible) values, and each record is unique.

### The Problem (Unnormalized Data)
Imagine a `Users` table where we store a user's phone numbers in a single column:

| UserID | Name | PhoneNumbers |
| :--- | :--- | :--- |
| 1 | Alice | 555-1234, 555-9876 |
| 2 | Bob | 555-4444 |

*Why is this bad?* If you need to search for the number `555-9876`, the database has to scan the entire string inside the `PhoneNumbers` column, which is horribly inefficient and prevents indexing.

### The Solution (1NF)
To achieve 1NF, split the comma-separated values into individual rows.

| UserID | Name | PhoneNumber |
| :--- | :--- | :--- |
| 1 | Alice | 555-1234 |
| 1 | Alice | 555-9876 |
| 2 | Bob | 555-4444 |

*(Note: While this satisfies 1NF, you can see it introduces redundancy with the `Name` column. That is fixed in the next forms).*

---

## 2. Second Normal Form (2NF)

**The Rule:** A table must be in 1NF, and all non-key attributes must be fully dependent on the *entire* primary key. (This rule only applies if the table has a composite primary key).

### The Problem
Imagine a `Student_Courses` table with a composite primary key consisting of `StudentID` and `CourseID`.

| StudentID (PK) | CourseID (PK) | Grade | CourseName |
| :--- | :--- | :--- | :--- |
| 1 | 101 | A | Math |
| 1 | 102 | B | History |
| 2 | 101 | C | Math |

*Why is this bad?* `Grade` depends on both the Student and the Course (Full Dependency). However, `CourseName` only depends on the `CourseID` (Partial Dependency). If we rename "Math" to "Advanced Math", we have to update multiple rows.

### The Solution (2NF)
Split the table into two. One for the Course details, and one for the Student-Course mapping.

**Courses Table:**
| CourseID (PK) | CourseName |
| :--- | :--- |
| 101 | Math |
| 102 | History |

**Student_Courses Table:**
| StudentID (PK) | CourseID (PK) | Grade |
| :--- | :--- | :--- |
| 1 | 101 | A |
| 1 | 102 | B |
| 2 | 101 | C |

---

## 3. Third Normal Form (3NF)

**The Rule:** A table must be in 2NF, and there must be no transitive dependencies. (A non-key column cannot depend on another non-key column).

### The Problem
Imagine an `Orders` table:

| OrderID (PK) | TotalAmount | CustomerID | CustomerZipCode |
| :--- | :--- | :--- | :--- |
| 1 | $100 | 99 | 90210 |
| 2 | $50 | 99 | 90210 |

*Why is this bad?* `CustomerZipCode` depends on `CustomerID`, not on the `OrderID`. This is a transitive dependency (`OrderID` -> `CustomerID` -> `CustomerZipCode`). If customer 99 moves, we have to update their zip code on every single order they've ever placed.

### The Solution (3NF)
Move the customer details to a dedicated `Customers` table.

**Customers Table:**
| CustomerID (PK) | CustomerZipCode |
| :--- | :--- |
| 99 | 90210 |

**Orders Table:**
| OrderID (PK) | TotalAmount | CustomerID (FK) |
| :--- | :--- | :--- |
| 1 | $100 | 99 |
| 2 | $50 | 99 |

---

## 4. Boyce-Codd Normal Form (BCNF)

**The Rule:** Often called "3.5NF", it strictly dictates that for every non-trivial dependency X -> Y, X must be a superkey. It handles edge cases involving multiple overlapping candidate keys.

Most production databases stop at 3NF. Pushing further to BCNF, 4NF, or 5NF can sometimes result in "over-normalization," where data is fragmented across so many tables that querying it requires a dozen slow `JOIN` operations.

---

## Denormalization (The Real World)

While academics push for strict normalization, real-world data engineers often intentionally **denormalize** data for read-heavy applications (OLAP/Data Warehouses). 

For example, constantly joining the `Orders`, `Customers`, and `Products` tables to generate a daily sales report might be too slow. Instead, engineers will create a denormalized "flat" table that contains redundancy but allows for blazing-fast `SELECT` queries without joins. 

**Golden Rule:** Normalize for Writes (OLTP). Denormalize for Reads (OLAP).
