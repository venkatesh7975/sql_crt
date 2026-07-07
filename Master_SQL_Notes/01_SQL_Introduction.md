# Topic 1: SQL Introduction 🚀

---

## 1. Definition

### What is it?
**SQL** stands for **Structured Query Language**. It is the standard language used to communicate with Relational Database Management Systems (RDBMS). Think of it as the language databases understand. If you want a database to save data, search for data, update data, or delete data, you have to "speak" SQL to it.

### Why do we need it?
Imagine an Excel sheet with 10 million rows. If you try to open it, your computer will likely crash. If multiple people try to edit it at the same time, it becomes a mess. SQL solves this by storing data on powerful servers and allowing thousands of users to read and write data simultaneously, securely, and lightning-fast. 

### When should we use it?
Whenever data needs to be stored in a structured format (like tables with rows and columns), relationships need to be maintained (e.g., matching a user to their orders), and fast retrieval is required.

### Real-life analogy
Think of a **Database** as a huge, highly organized Library. 
Think of the **Tables** as the bookshelves.
Think of the **Data** as the books.
**SQL** is the highly efficient Librarian. You don't search the library yourself; you ask the Librarian (SQL) to find the book for you, add a new book, or remove an old one.

### Industry use case
**Swiggy/Zomato:** When you open the app, SQL is used behind the scenes to fetch all the restaurants currently open in your specific location and display their menus.

---

## 2. Syntax

Because SQL Introduction covers the broad concept of SQL, we will introduce the most fundamental syntax you will ever use: retrieving data.

```sql
SELECT column_name
FROM table_name
WHERE condition;
```

* **SELECT**: "What do you want to see?" (Tells the database which columns to fetch).
* **FROM**: "Where should I look?" (Tells the database which table holds the data).
* **WHERE**: "What are the rules?" (Filters the data so you only get what you actually need).

---

## 3. Create Database

Before we can create tables or write queries, we need a database.

```sql
-- Creates a new database for our Swiggy-like app
CREATE DATABASE FoodDeliveryDB;

-- Tells the SQL engine that we want to work inside this specific database
USE FoodDeliveryDB;
```

---

## 4. Create Tables

Let's create two realistic tables: `Users` and `Orders`. 

```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50) DEFAULT 'Unknown',
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    RestaurantName VARCHAR(100) NOT NULL,
    TotalAmount DECIMAL(10, 2) CHECK (TotalAmount > 0),
    OrderDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
```
* **PRIMARY KEY**: Uniquely identifies each row (like an ID card).
* **FOREIGN KEY**: Links the `Orders` table to the `Users` table.
* **NOT NULL**: Ensures a column cannot be left empty.
* **UNIQUE**: Ensures no two users have the same email.
* **AUTO_INCREMENT**: Automatically generates the next number (1, 2, 3...) when a new row is added.

---

## 5. Insert Sample Data

```sql
-- Inserting data into Users table
INSERT INTO Users (UserName, Email, City, JoinDate) VALUES 
('Rahul Sharma', 'rahul@gmail.com', 'Mumbai', '2023-01-15'),
('Priya Singh', 'priya@yahoo.com', 'Delhi', '2023-02-20'),
('Amit Kumar', 'amit@gmail.com', 'Bangalore', '2023-03-10'),
('Neha Gupta', 'neha@hotmail.com', 'Mumbai', '2023-04-05'),
('Vikram Verma', 'vikram@gmail.com', NULL, '2023-05-12'), -- NULL value for City
('Rahul Sharma', 'rahul.s@outlook.com', 'Pune', '2023-06-01'); -- Duplicate name, different email

-- Inserting data into Orders table
INSERT INTO Orders (UserID, RestaurantName, TotalAmount, OrderDate) VALUES 
(1, 'Burger King', 350.50, '2023-06-15'),
(2, 'Dominos', 550.00, '2023-06-16'),
(1, 'KFC', 420.00, '2023-06-18'),
(3, 'Truffles', 800.00, '2023-06-20'),
(4, 'Subway', 250.00, '2023-06-21'),
(NULL, 'Guest Checkout', 150.00, '2023-06-22'), -- Missing reference (Guest order)
(3, 'Truffles', 800.00, '2023-06-20'); -- Duplicate order for demonstration
```

---

## 6. Show Initial Tables

### `Users` Table
| UserID | UserName | Email | City | JoinDate |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Rahul Sharma | rahul@gmail.com | Mumbai | 2023-01-15 |
| 2 | Priya Singh | priya@yahoo.com | Delhi | 2023-02-20 |
| 3 | Amit Kumar | amit@gmail.com | Bangalore | 2023-03-10 |
| 4 | Neha Gupta | neha@hotmail.com | Mumbai | 2023-04-05 |
| 5 | Vikram Verma | vikram@gmail.com | *NULL* | 2023-05-12 |
| 6 | Rahul Sharma | rahul.s@outlook.com | Pune | 2023-06-01 |

### `Orders` Table
| OrderID | UserID | RestaurantName | TotalAmount | OrderDate |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | Burger King | 350.50 | 2023-06-15 |
| 2 | 2 | Dominos | 550.00 | 2023-06-16 |
| 3 | 1 | KFC | 420.00 | 2023-06-18 |
| 4 | 3 | Truffles | 800.00 | 2023-06-20 |
| 5 | 4 | Subway | 250.00 | 2023-06-21 |
| 6 | *NULL* | Guest Checkout | 150.00 | 2023-06-22 |
| 7 | 3 | Truffles | 800.00 | 2023-06-20 |

---

## 7. Explain the Concept

### Visually:
User -> App Interface -> Internet -> SQL Database Server -> Hard Drive. 
SQL is the language sent through the internet to the server.

### The Logic:
SQL is a **declarative** language. In programming languages like Python or Java, you have to write step-by-step logic (loops, if conditions) on *how* to find data. In SQL, you simply declare *what* you want. You say `SELECT * FROM Users WHERE City = 'Mumbai'`, and the database engine automatically figures out the fastest way to get it for you. 

### Internal workings:
When you send a query, the SQL Engine:
1. **Parses** it (Checks for spelling/syntax mistakes).
2. **Optimizes** it (Figures out the fastest route to the data).
3. **Executes** it (Goes to the hard disk, grabs the data, and sends it back to you).

---

## 8. Basic Examples

**Easy: Fetching all data**
```sql
SELECT * FROM Users;
```
*The `*` means "give me all columns".*

**Medium: Fetching specific columns**
```sql
SELECT UserName, Email FROM Users;
```
*Better for performance because you aren't downloading data you don't need.*

**Advanced (Preview): Filtering data**
```sql
SELECT UserName FROM Users WHERE City = 'Mumbai';
```

---

## 9. Real Industry Examples

* **Netflix**: `SELECT MovieName FROM Movies WHERE Genre = 'Action' AND Rating > 4.5;` (Finding top action movies for a user).
* **Banking**: `SELECT Balance FROM Accounts WHERE AccountNumber = '123456789';` (Checking your ATM balance).
* **Amazon**: `SELECT ProductName, Price FROM Inventory WHERE Stock > 0;` (Showing only items that are in stock).

---

## 10. Multiple Queries

Here are queries you might write on your first day learning SQL, progressing in difficulty.

**Query 1: View all orders**
```sql
SELECT * FROM Orders;
```
| OrderID | UserID | RestaurantName | TotalAmount | OrderDate |
| :--- | :--- | :--- | :--- | :--- |
| ... | ... | (All rows from Orders table) | ... | ... |

**Query 2: Find all orders above ₹400**
```sql
SELECT * FROM Orders WHERE TotalAmount > 400;
```
*Logic: The database scans the `TotalAmount` column and only returns rows where the condition is True.*
| OrderID | UserID | RestaurantName | TotalAmount | OrderDate |
| :--- | :--- | :--- | :--- | :--- |
| 2 | 2 | Dominos | 550.00 | 2023-06-16 |
| 3 | 1 | KFC | 420.00 | 2023-06-18 |
| 4 | 3 | Truffles | 800.00 | 2023-06-20 |
| 7 | 3 | Truffles | 800.00 | 2023-06-20 |

**Query 3: Find users who live in Mumbai**
```sql
SELECT UserName FROM Users WHERE City = 'Mumbai';
```
| UserName |
| :--- |
| Rahul Sharma |
| Neha Gupta |

**Query 4: Find users whose city is NOT known (NULL)**
```sql
SELECT UserName FROM Users WHERE City IS NULL;
```
*Logic: `NULL` means absence of data. You cannot use `= NULL`, you must use `IS NULL`.*
| UserName |
| :--- |
| Vikram Verma |

**Query 5: Find unique cities where our users live**
```sql
SELECT DISTINCT City FROM Users;
```
*Logic: `DISTINCT` removes duplicate values from the output.*
| City |
| :--- |
| Mumbai |
| Delhi |
| Bangalore |
| NULL |
| Pune |

---

## 11. Visual Explanation

```text
How SQL Talks to Data:

[ Your Query ]  --> SELECT UserName FROM Users WHERE City = 'Delhi';

                      DATABASE ENGINE
                     /               \
            (1) Parse Syntax      (2) Find Table 'Users'
                    |                 |
            (3) Filter Rows       (4) Return Data
                 (City='Delhi')       (Priya Singh)

[ Output ] <--------------------------
```

---

## 12. Common Mistakes

**Mistake 1: Forgetting the semicolon at the end (in some environments).**
```sql
-- Wrong
SELECT * FROM Users

-- Correct
SELECT * FROM Users;
```
*Why it happens: Beginners forget that SQL uses `;` to know when a command finishes.*

**Mistake 2: Using double quotes for strings instead of single quotes.**
```sql
-- Wrong (Depending on dialect, this might look for a column named Mumbai)
SELECT * FROM Users WHERE City = "Mumbai";

-- Correct
SELECT * FROM Users WHERE City = 'Mumbai';
```
*Why it happens: Programmers coming from Java/Python are used to double quotes. In SQL, single quotes denote strings.*

---

## 13. Performance Notes

* **`SELECT *` is dangerous:** In production, never use `SELECT *` on large tables. If a table has 100 columns and 1 billion rows, you will crash the server trying to download it all. Always specify the exact columns you need: `SELECT UserName, City FROM Users;`.
* **Execution Behavior:** SQL doesn't read top-to-bottom. It first figures out the `FROM` table, then applies the `WHERE` filters, and only at the very end does it process the `SELECT` to show the columns.
* **Indexes:** As tables get huge, searching becomes slow. SQL uses "Indexes" (like the index at the back of a textbook) to instantly find rows without scanning the whole table.

---

## 14. Interview Questions

**Basic**
1. **What does SQL stand for?**
   *Answer: Structured Query Language.*
2. **What is the difference between SQL and a Database?**
   *Answer: SQL is the language. The Database (like MySQL, PostgreSQL) is the software program that understands the language and stores the data.*
3. **What is a Primary Key?**
   *Answer: A unique identifier for every row in a table. It cannot be NULL and must be unique.*
4. **What is a Foreign Key?**
   *Answer: A column in one table that points to the Primary Key in another table, creating a relationship between them.*

**Intermediate**
5. **Is SQL case-sensitive?**
   *Answer: The keywords (SELECT, FROM) are not case-sensitive. However, the data inside the tables (e.g., 'Mumbai' vs 'mumbai') is usually case-sensitive, depending on the database's collation settings.*
6. **Why shouldn't you use `SELECT *` in production code?**
   *Answer: It wastes network bandwidth, memory, and CPU by retrieving columns that the application might not even need.*
7. **What happens if you omit the `WHERE` clause in a `DELETE` statement?**
   *Answer: You will delete every single row in the table! Always double-check your WHERE clause.*

**Advanced**
8. **What is the difference between RDBMS and NoSQL?**
   *Answer: RDBMS (SQL) stores data in strict, predefined tables with rows and columns. NoSQL (like MongoDB) stores data in flexible formats like JSON documents, making it better for unstructured data but harder for complex relationship querying.*
9. **How does the SQL execution engine process a query conceptually?**
   *Answer: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT.*

*(Additional specific queries will be expanded in later functional topics).*

---

## 15. Practice Questions

**Easy**
1. Write a query to fetch all columns from the `Orders` table.
2. Write a query to fetch only the `Email` column from the `Users` table.
3. Write a query to find the `TotalAmount` for OrderID 3.

**Medium**
4. Write a query to fetch the names of users who joined after '2023-03-01'.
5. Write a query to find all orders placed at 'Truffles'.
6. Write a query to find all unique restaurant names in our `Orders` table.

**Hard**
7. Write a query to find the UserID of the person who spent the most money in a single order. (Hint: Requires sorting and limiting, which you'll learn soon!)
8. Write a query to find users who do not have a city listed.

---

## 16. Summary Table

| Feature | Description | Use Case |
| :--- | :--- | :--- |
| **SQL** | Structured Query Language | To talk to databases |
| **RDBMS** | Relational Database Management System | MySQL, Postgres, Oracle, SQL Server |
| **SELECT** | Command to retrieve data | `SELECT Name FROM Users;` |
| **FROM** | Specifies the target table | `FROM Users` |
| **WHERE** | Filters the data based on conditions | `WHERE Age > 18` |

---

## 17. Cheat Sheet

* **Create DB:** `CREATE DATABASE db_name;`
* **Use DB:** `USE db_name;`
* **Create Table:** `CREATE TABLE table_name (col1 datatype, col2 datatype);`
* **Insert Data:** `INSERT INTO table_name (col1) VALUES (val1);`
* **Read Data:** `SELECT col1, col2 FROM table_name;`
* **Filter Data:** `SELECT * FROM table_name WHERE col1 = 'value';`
* **Golden Rule:** Always end queries with a semicolon `;`. Single quotes `'` for strings.

---

## 18. Revision Notes

* **SQL is declarative:** You tell it what you want, not how to get it.
* Data is stored in **Tables** (Rows and Columns).
* **Primary Keys** must be unique and not null.
* **Foreign Keys** link tables together.
* Avoid `SELECT *` in real-world large databases to save performance.
* Check your `WHERE` condition twice before running `UPDATE` or `DELETE` commands!
