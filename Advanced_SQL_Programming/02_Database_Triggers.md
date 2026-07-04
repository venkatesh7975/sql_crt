# Database Triggers in MySQL

A **Trigger** is a named database object that is associated with a table, and it activates automatically (it "triggers") whenever a specific event occurs for that table. 

Triggers are essentially automated, invisible listeners.

---

## 1. The Anatomy of a Trigger

A trigger requires three main specifications:
1.  **Timing**: `BEFORE` or `AFTER`.
2.  **Event**: `INSERT`, `UPDATE`, or `DELETE`.
3.  **Table**: The table to listen to.

**The `NEW` and `OLD` Keywords:**
Inside a trigger, you have access to special keywords that reference the row being modified:
*   `NEW.column_name`: The new value being written (Available in `INSERT` and `UPDATE`).
*   `OLD.column_name`: The old value that was just overwritten or deleted (Available in `UPDATE` and `DELETE`).

---

## 2. Example 1: Data Validation (`BEFORE INSERT`)

Let's say we want to absolutely ensure that no user is ever inserted into the database with a negative age, regardless of what bugs exist in the backend application code.

```sql
DELIMITER //

CREATE TRIGGER prevent_negative_age
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF NEW.Age < 0 THEN
        -- Force the age to 0, or throw an error
        SET NEW.Age = 0;
    END IF;
END //

DELIMITER ;
```
*If an app tries to run `INSERT INTO Users (Name, Age) VALUES ('John', -5)`, the trigger intercepts it, changes `-5` to `0`, and then writes it to the disk.*

---

## 3. Example 2: Audit Logging (`AFTER UPDATE`)

This is the most common use case for triggers in the real world. We want to keep a historical log of every time an employee's salary changes.

**Setup the Audit Table:**
```sql
CREATE TABLE SalaryAudit (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Create the Trigger:**
```sql
DELIMITER //

CREATE TRIGGER log_salary_changes
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    -- Only log if the salary actually changed
    IF OLD.Salary != NEW.Salary THEN
        INSERT INTO SalaryAudit (EmployeeID, OldSalary, NewSalary)
        VALUES (OLD.EmployeeID, OLD.Salary, NEW.Salary);
    END IF;
END //

DELIMITER ;
```
*Now, whenever an `UPDATE Employees SET Salary = 90000 WHERE EmployeeID = 5` runs, the trigger automatically spawns an audit trail record.*

---

## 4. Example 3: Enforcing Business Rules (`BEFORE DELETE`)

We want to prevent anyone from deleting an Invoice that has already been marked as 'Paid'.

```sql
DELIMITER //

CREATE TRIGGER prevent_paid_invoice_deletion
BEFORE DELETE ON Invoices
FOR EACH ROW
BEGIN
    IF OLD.Status = 'Paid' THEN
        -- SIGNAL SQLSTATE '45000' is the MySQL way of throwing a custom error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Cannot delete an invoice that has already been paid.';
    END IF;
END //

DELIMITER ;
```

---

## 5. The Danger of Triggers (Why to avoid overusing them)

While powerful, senior engineers often advise using triggers sparingly. 

**The "Magic" Problem:**
Imagine a junior developer is trying to insert a record into `Table A`. Suddenly, they get a weird error about `Table B`, or they notice `Table B` is miraculously updating itself. 
Because triggers happen invisibly in the background, they can create absolute chaos when debugging. 

**Best Practice:** Use triggers for strictly database-level concerns (like Audit Logging or strict data integrity constraints). Keep actual *business logic* (like sending a welcome email or calculating a discount) in the application code or an explicit Stored Procedure.
