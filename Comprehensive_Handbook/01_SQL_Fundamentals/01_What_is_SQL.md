# What is SQL?

---

## 1. Introduction

**SQL** stands for **Structured Query Language**. It is the standard programming language used to communicate with, manage, and manipulate relational databases. If a database is an organized collection of data, SQL is the tool you use to ask questions about that data and make changes to it.

Imagine a massive Excel spreadsheet with millions of rows. Opening that file would crash your computer. SQL allows you to quickly filter, analyze, and update that data in milliseconds without needing to load the entire dataset into memory.

---

## 2. What Can SQL Do?

SQL is incredibly powerful. With it, you can:
*   **Query Data**: Retrieve specific information (e.g., "Find all users who signed up today").
*   **Insert Data**: Add new records (e.g., "Add a new customer to the database").
*   **Update Data**: Modify existing records (e.g., "Change Bob's email address").
*   **Delete Data**: Remove records (e.g., "Delete a canceled order").
*   **Manage Schema**: Create, alter, or drop entirely new tables and databases.
*   **Control Access**: Grant or revoke permissions for other users to access data.

---

## 3. SQL Sub-Languages

SQL is conceptually divided into several distinct sub-languages based on their function. Interviewers frequently test your knowledge of these acronyms.

### DDL (Data Definition Language)
Used to define or modify the structure (schema) of the database. These commands affect tables, not individual rows.
*   `CREATE`: Creates a new table, view, or database.
*   `ALTER`: Modifies an existing database object (e.g., adding a column).
*   `DROP`: Deletes an entire table, view, or database.
*   `TRUNCATE`: Empties a table completely but leaves the structure intact.

### DML (Data Manipulation Language)
Used to manipulate the actual data (rows) stored inside the tables.
*   `INSERT`: Adds new rows.
*   `UPDATE`: Modifies existing rows.
*   `DELETE`: Removes existing rows.

### DQL (Data Query Language)
Used specifically to retrieve data.
*   `SELECT`: The most commonly used command. It fetches data from the database. *(Note: Some purists consider `SELECT` to be part of DML).*

### DCL (Data Control Language)
Used to control access and permissions.
*   `GRANT`: Gives a user access privileges.
*   `REVOKE`: Withdraws user access privileges.

### TCL (Transaction Control Language)
Used to manage transactions (groups of SQL statements that must succeed or fail together).
*   `COMMIT`: Saves the work done in the current transaction.
*   `ROLLBACK`: Reverts the changes made in the current transaction.
*   `SAVEPOINT`: Sets a point within a transaction to which you can roll back.

---

## 4. Why Learn SQL?

Despite being invented in the 1970s, SQL remains one of the most highly sought-after skills in tech.
1.  **Universality**: Almost every tech company (Google, Netflix, Uber, Amazon) relies heavily on relational databases.
2.  **Foundation for Big Data**: Modern Big Data tools (like Snowflake, BigQuery, Hive, and Spark SQL) all use SQL syntax to query petabytes of data.
3.  **Data Driven Decisions**: Whether you are a Software Engineer building APIs, a Data Scientist training models, or a Product Manager analyzing metrics, SQL is the gateway to accessing your company's data.

---

## 5. Interview Tips
*   **Know the Acronyms**: Be prepared to answer "What is the difference between DDL and DML?" or "Is TRUNCATE a DDL or DML command?" (Answer: TRUNCATE is DDL, DELETE is DML).
*   **SQL is Declarative**: Unlike Python or Java (which are imperative languages where you tell the computer *how* to do something step-by-step), SQL is **declarative**. You simply tell the database engine *what* you want (e.g., `SELECT * FROM users`), and the database query optimizer figures out the most efficient way to fetch it.
