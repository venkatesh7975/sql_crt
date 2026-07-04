# First, Second, and Third Normal Forms

---

## 1. What is Normalization?

**Normalization** is the process of organizing data in a database to reduce redundancy (duplication) and improve data integrity. 

It involves breaking down massive, spreadsheet-like tables into multiple smaller, related tables (linked by Primary and Foreign Keys).

In database theory, there are stages of normalization called "Normal Forms". In the industry, bringing a database up to the **Third Normal Form (3NF)** is the standard benchmark for a "well-designed" relational database.

---

## 2. 1NF: First Normal Form (Atomicity)

**The Rule:** Every cell in a table must contain a single, atomic value. No lists or arrays are allowed in a single column.

**The Violation (Unnormalized):**
| user_id | name | phone_numbers |
| :--- | :--- | :--- |
| 1 | Alice | 555-1234, 555-9876 |

*(How do you `JOIN` or `WHERE` search on Alice's second phone number? It's buried in a comma-separated string!)*

**The 1NF Solution:**
Create a separate row for every phone number, OR create a separate `user_phones` table.
| user_id | name | phone_number |
| :--- | :--- | :--- |
| 1 | Alice | 555-1234 |
| 1 | Alice | 555-9876 |

---

## 3. 2NF: Second Normal Form (Partial Dependency)

**The Rule:** The table must be in 1NF, AND every non-key column must depend on the *entire* Primary Key, not just a part of it. (This primarily applies to tables that have Composite Primary Keys).

**The Violation (1NF but not 2NF):**
Imagine a `student_courses` table with a Composite Primary Key of (`student_id`, `course_id`).
| student_id | course_id | grade | course_name | instructor_name |
| :--- | :--- | :--- | :--- | :--- |
| 101 | C1 | A | Biology | Dr. Smith |
| 102 | C1 | B | Biology | Dr. Smith |

*   Does `grade` depend on both the student and the course? Yes.
*   Does `course_name` depend on the student? **No.** It only depends on the `course_id`. This is a Partial Dependency. If Dr. Smith changes his name, we have to update it in 1,000 different student rows!

**The 2NF Solution:**
Split it into two tables.
1. `courses` table: (`course_id`, `course_name`, `instructor_name`)
2. `student_courses` table: (`student_id`, `course_id`, `grade`)

---

## 4. 3NF: Third Normal Form (Transitive Dependency)

**The Rule:** The table must be in 2NF, AND every non-key column must depend *only* on the Primary Key. You cannot have non-key columns depending on other non-key columns.

**The Violation (2NF but not 3NF):**
Imagine an `employees` table with a Primary Key of `emp_id`.
| emp_id | name | department_id | department_name |
| :--- | :--- | :--- | :--- |
| 1 | Alice | D1 | Engineering |
| 2 | Bob | D1 | Engineering |

*   Does `department_id` depend on the employee? Yes.
*   Does `department_name` depend on the employee? **No.** It depends entirely on the `department_id`. This is a Transitive Dependency (`emp_id` -> `department_id` -> `department_name`). 

**The 3NF Solution:**
Break out the departments!
1. `departments` table: (`department_id`, `department_name`)
2. `employees` table: (`emp_id`, `name`, `department_id`)

*(If you notice, 2NF and 3NF are basically achieving the exact same goal: stop duplicating data!)*

---

## 5. Interview Tips
*   **The Catchphrase:** The easiest way to remember 1NF, 2NF, and 3NF for an interview is the famous database mantra:
    *   **"Every non-key column must depend on the key (1NF), the whole key (2NF), and nothing but the key (3NF), so help me Codd."** (Edgar Codd is the inventor of the relational database model).
*   **Denormalization:** "Is it ever a good idea to break 3NF and duplicate data on purpose?"
    *   **Answer:** "Yes! This is called **Denormalization**. While 3NF is great for write-heavy OLTP databases (to ensure data integrity), it requires massive, slow Joins to read the data back. In Data Warehouses (OLAP) meant for reporting, we frequently denormalize data and allow duplication to vastly speed up `SELECT` read queries."
