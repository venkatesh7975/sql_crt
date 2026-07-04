# ALTER DATABASE

---

## 1. Modifying a Database

The `ALTER DATABASE` command is a Data Definition Language (DDL) statement used to change the overall characteristics of an existing database. 

**Important Note:** You cannot use `ALTER DATABASE` to change the name of the database. Renaming a database in MySQL is notoriously difficult and usually requires creating a new database, dumping the tables from the old one, and importing them into the new one.

`ALTER DATABASE` is primarily used to change the **Character Set** and **Collation** of the database.

---

## 2. Changing the Character Set and Collation

As discussed in the `CREATE DATABASE` chapter, the Character Set dictates what kind of raw binary characters can be stored (like standard letters vs emojis), and the Collation dictates how those characters are sorted and compared (e.g., does 'A' equal 'a'?).

If a database was accidentally created with a limited character set, you can upgrade it.

### Syntax
```sql
ALTER DATABASE my_database 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

### What does this actually do?
Running this command changes the *default* settings for the database.
*   **It DOES NOT automatically convert existing tables.** If you have a `users` table that was created with the old `latin1` character set, it will remain `latin1`. You will have to run `ALTER TABLE` on it separately.
*   **It DOES apply to new tables.** Any table created inside `my_database` *after* running this `ALTER DATABASE` command will automatically inherit `utf8mb4` and `utf8mb4_unicode_ci` unless specified otherwise.

---

## 3. Read-Only Mode (Advanced)

In newer versions of MySQL (8.0+), you can use `ALTER DATABASE` to mark a database as strictly Read-Only. This is incredibly useful for database migrations, archiving legacy data, or preventing accidental data deletion during a server maintenance window.

```sql
-- Lock the database (No INSERT, UPDATE, DELETE, or DDL allowed)
ALTER DATABASE my_database READ ONLY = 1;

-- Unlock the database
ALTER DATABASE my_database READ ONLY = 0;
```

---

## 4. Interview Tips
*   **The Rename Question:** "How do you rename a database in MySQL using a SQL command?"
    *   **Answer:** "You can't. There is no `RENAME DATABASE` command in modern MySQL for safety reasons. To rename a database, you must use `mysqldump` to export the data, create a new database with the correct name, import the data, and then `DROP` the old database."
*   **Retroactive Altering:** Remember that altering the database defaults does not magically fix tables that were created before the alteration.
