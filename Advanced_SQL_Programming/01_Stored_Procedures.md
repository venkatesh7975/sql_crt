# Stored Procedures in MySQL

A **Stored Procedure** is a prepared SQL code that you can save so the code can be reused over and over again. Instead of a backend application (like Node.js or Python) sending a massive 50-line SQL query over the network, it can simply call a stored procedure by name.

Stored procedures allow you to embed **business logic** (like `IF/ELSE` statements and loops) directly into the database engine.

---

## 1. Basic Syntax: DELIMITER and CREATE

Because a stored procedure contains multiple SQL statements separated by semicolons (`;`), we have to temporarily change the MySQL `DELIMITER` so the engine doesn't execute the script prematurely.

```sql
DELIMITER //

CREATE PROCEDURE GetAllActiveUsers()
BEGIN
    SELECT * FROM Users WHERE Status = 'Active';
END //

DELIMITER ;
```

**To execute the procedure:**
```sql
CALL GetAllActiveUsers();
```

---

## 2. Parameters: IN, OUT, and INOUT

Procedures become powerful when you pass data into them, and extract data out of them.
*   **IN**: Passes a value into the procedure.
*   **OUT**: Passes a value back to the caller.
*   **INOUT**: Can do both.

### Example: A Procedure with IN and OUT parameters
```sql
DELIMITER //

CREATE PROCEDURE GetUserCountByStatus(
    IN userStatus VARCHAR(20), 
    OUT totalCount INT
)
BEGIN
    SELECT COUNT(*) INTO totalCount 
    FROM Users 
    WHERE Status = userStatus;
END //

DELIMITER ;
```

**To call it and view the result:**
```sql
-- Call the procedure and store the result in a session variable (@count)
CALL GetUserCountByStatus('Active', @count);

-- View the result
SELECT @count;
```

---

## 3. Control Flow: IF / ELSE

You can write logic directly inside the procedure.

```sql
DELIMITER //

CREATE PROCEDURE CheckStock(IN productId INT)
BEGIN
    DECLARE currentStock INT;
    
    -- Fetch the stock into a local variable
    SELECT StockQuantity INTO currentStock 
    FROM Products 
    WHERE ProductID = productId;
    
    -- Business Logic
    IF currentStock > 50 THEN
        SELECT 'Stock is healthy' AS Status;
    ELSEIF currentStock > 0 THEN
        SELECT 'Stock is running low' AS Status;
    ELSE
        SELECT 'Out of stock!' AS Status;
    END IF;
END //

DELIMITER ;
```

---

## 4. Real-World Example: Safe E-Commerce Checkout

The best use case for a stored procedure is executing a **Transaction**. If a user checks out an online cart, we must:
1. Deduct the inventory.
2. Charge the user.
3. If the inventory deduction fails, we must NOT charge the user (Rollback).

```sql
DELIMITER //

CREATE PROCEDURE ProcessCheckout(
    IN p_UserID INT, 
    IN p_ProductID INT, 
    IN p_Quantity INT, 
    OUT p_Success BOOLEAN
)
BEGIN
    DECLARE currentStock INT;
    
    -- Start Transaction
    START TRANSACTION;
    
    -- Check Stock
    SELECT StockQuantity INTO currentStock FROM Products WHERE ProductID = p_ProductID FOR UPDATE;
    
    IF currentStock >= p_Quantity THEN
        -- 1. Deduct Stock
        UPDATE Products SET StockQuantity = StockQuantity - p_Quantity WHERE ProductID = p_ProductID;
        
        -- 2. Create Order Record
        INSERT INTO Orders (UserID, ProductID, Quantity, Status) VALUES (p_UserID, p_ProductID, p_Quantity, 'Processing');
        
        -- Commit Transaction
        COMMIT;
        SET p_Success = TRUE;
    ELSE
        -- Not enough stock, cancel everything
        ROLLBACK;
        SET p_Success = FALSE;
    END IF;
END //

DELIMITER ;
```

---

## 5. Pros and Cons of Stored Procedures

**Pros:**
*   **Reduced Network Traffic:** Only the `CALL` command travels over the network, not hundreds of lines of SQL.
*   **Security:** You can grant a user permission to execute a procedure without giving them permission to read/write to the underlying tables.
*   **Centralized Logic:** If 3 different apps (Web, iOS, Android) use the DB, the logic is in one place.

**Cons:**
*   **Hard to Debug:** Stepping through code in a database is much harder than debugging in Python/Java.
*   **Vendor Lock-in:** MySQL procedures are written differently than PostgreSQL or SQL Server procedures. Migrating is painful.
*   **Version Control:** Procedures live in the database, making them slightly harder to track in Git compared to application code.
