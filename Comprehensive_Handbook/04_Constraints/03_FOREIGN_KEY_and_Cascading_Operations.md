# FOREIGN KEY and Cascading Operations

---

## 1. What is a Foreign Key?

If the Primary Key is the anchor that identifies a row, the **Foreign Key** is the rope that ties one table to another.
A Foreign Key is a column in Table B that strictly references the Primary Key of Table A.

### Referential Integrity
The entire purpose of a Foreign Key is to enforce **Referential Integrity**. It prevents "Orphaned Records".
*   Imagine an `orders` table and a `users` table. 
*   If an order is placed by `user_id = 5`, the Foreign Key guarantees that a user with ID 5 *actually exists* in the `users` table. 
*   If you attempt to insert an order for `user_id = 9999` (who doesn't exist), the database will aggressively reject the `INSERT`.

---

## 2. Basic Syntax

Like Composite Keys, Foreign Keys are typically declared at the bottom of the `CREATE TABLE` statement.

```sql
-- 1. Create the parent table first
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

-- 2. Create the child table that references the parent
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_total DECIMAL(10,2),
    user_id INT, -- This is our target column
    
    -- Define the Foreign Key constraint
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### Naming Constraints (Best Practice)
It is highly recommended to explicitly name your foreign key constraints. If you don't, MySQL generates a random, ugly name (like `orders_ibfk_1`). If you ever need to drop the foreign key later, you will want a clean, predictable name.

```sql
CREATE TABLE orders (
    -- ...columns...
    user_id INT,
    CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 3. What happens if a Parent is Deleted?

Referential Integrity is a double-edged sword. 
What happens if Alice (`user_id = 1`) decides to delete her account, but she has 10 past orders in the `orders` table?
If the database allows you to delete Alice, those 10 orders would suddenly belong to a ghost. The Foreign Key prevents this!

By default, if you run `DELETE FROM users WHERE id = 1;`, MySQL will throw an error and block the deletion to protect the integrity of the `orders` table. This is called the **RESTRICT** action.

---

## 4. Cascading Operations

You can customize how the database reacts when a parent record is deleted or updated by using **Cascading Operations** appended to the end of the Foreign Key definition.

### 1. ON DELETE CASCADE (The Domino Effect)
If the parent record is deleted, the database will automatically and instantly delete all child records that reference it.
*   *Use Case:* If you delete a Reddit Post, you absolutely want all the Comments attached to that post to be deleted automatically.
```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

### 2. ON DELETE SET NULL (The Ghosting Effect)
If the parent record is deleted, the child records are kept alive, but their Foreign Key column is updated to `NULL`.
*   *Use Case:* If a Sales Rep quits and is deleted from the `employees` table, you do not want to delete all their historical `sales_records`. Instead, you set the rep ID on those sales to `NULL` (meaning "handled by a former employee").
```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
```

### 3. ON DELETE RESTRICT (The Default)
Blocks the deletion of the parent if any children exist. The application must manually delete all children first before it is allowed to delete the parent.

### 4. ON UPDATE CASCADE
If the actual value of the Primary Key in the parent table is updated (e.g., changing ID 5 to ID 900), `ON UPDATE CASCADE` will magically sweep through all child tables and change their `user_id` values from 5 to 900 to keep the link unbroken. 
*(Note: If you use Surrogate `AUTO_INCREMENT` Primary Keys, they never change, making `ON UPDATE` largely unnecessary).*

---

## 5. Interview Tips
*   **Orphaned Records:** Interviewers love asking "What is an orphaned record?" 
    *   **Answer:** "A record in a child table that references a primary key in a parent table that no longer exists. Foreign Keys strictly prevent this from happening."
*   **Performance:** Do Foreign Keys hurt performance? 
    *   **Answer:** "Yes, slightly. Every time you insert an `order`, the database must perform a quick read on the `users` table to verify the ID exists. Furthermore, in massive analytical databases (Data Warehouses), Foreign Keys are often completely disabled to maximize ingestion speed, moving the responsibility of data validation to the ETL pipeline."
