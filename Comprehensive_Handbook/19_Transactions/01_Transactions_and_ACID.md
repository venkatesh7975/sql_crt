# Transactions and ACID

---

## 1. The Bank Transfer Problem

Imagine a banking application. Alice is transferring $100 to Bob.
In the database, this requires two separate operations:
1.  `UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';`
2.  `UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';`

What happens if the server crashes exactly between Step 1 and Step 2?
Alice lost $100, but Bob never received it. The money evaporated. The database is now mathematically corrupted.

To prevent this, databases use **Transactions**.

---

## 2. What is a Transaction?

A Transaction is a wrapper around multiple SQL statements that forces the database to treat them as a single, indivisible unit of work.
The golden rule of a transaction is: **Either ALL of the steps succeed, or NONE of them happen.**

### Syntax: BEGIN, COMMIT, and ROLLBACK

To start a transaction, you issue the `BEGIN` command. 
If everything goes well, you save the changes permanently using `COMMIT`.

```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';

COMMIT; -- The money is now safely transferred.
```

If something goes wrong (e.g., an error is thrown, or you realize Bob doesn't exist), you issue a `ROLLBACK`. This instantly undoes all the `UPDATE`s back to the state they were in before you typed `BEGIN`.

```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
-- Oh no, the server lost connection to the authentication API!
ROLLBACK; -- Alice gets her $100 back instantly.
```

*(Note: In MySQL, standard `SELECT`, `INSERT`, `UPDATE` statements are "Auto-Committed". They are their own tiny transactions. You only need `BEGIN` when you want to group multiple statements together).*

---

## 3. The ACID Properties

Any enterprise database system (like MySQL, PostgreSQL, SQL Server) guarantees that their transactions adhere to the four **ACID** properties. This is a massively important theoretical concept in computer science.

1.  **A - Atomicity:** "All or Nothing." A transaction is an indivisible unit. If it has 5 steps, and step 5 fails, steps 1-4 are completely rolled back as if they never happened.
2.  **C - Consistency:** A transaction must bring the database from one valid state to another. It cannot violate foreign keys, unique constraints, or data types mid-transaction.
3.  **I - Isolation:** If two transactions are happening at the exact same millisecond, they should not interfere with each other. They should act as if they are isolated in a queue. (e.g., If Alice and Charlie both try to send Bob $100 at the same time, Bob should end up with $200, not $100).
4.  **D - Durability:** Once a transaction is `COMMIT`ted, it is permanent. Even if someone kicks the power cord out of the server 1 millisecond after the commit, the data will still be there when the server reboots. It has been written to the physical disk.

---

## 4. Interview Tips
*   **The ACID Acronym:** You must be able to recite what ACID stands for (Atomicity, Consistency, Isolation, Durability) and briefly explain the "Bank Transfer" metaphor to demonstrate Atomicity. 
*   **DDL vs DML in Transactions:** "Can you `ROLLBACK` a `DROP TABLE` command?"
    *   **Answer:** "In MySQL, NO. DDL commands (Data Definition Language: `CREATE`, `ALTER`, `DROP`) trigger an implicit commit and cannot be rolled back. Only DML commands (Data Manipulation Language: `INSERT`, `UPDATE`, `DELETE`) can be rolled back." *(Note: PostgreSQL is unique and actually DOES allow DDL rollbacks!)*
