# Scheduled Events in MySQL

The **MySQL Event Scheduler** allows you to schedule tasks (SQL statements or Stored Procedures) to run automatically at specific times or intervals, much like a Linux `CRON` job, but entirely internal to the database.

---

## 1. Enabling the Event Scheduler

By default, the event scheduler might be turned off to save system resources. You must enable it first.

```sql
-- Check if it is ON or OFF
SHOW VARIABLES LIKE 'event_scheduler';

-- Turn it ON
SET GLOBAL event_scheduler = ON;
```

---

## 2. Basic Syntax: Creating an Event

Events can be scheduled in two ways:
1.  **One-Time Event:** Runs once at a specific timestamp.
2.  **Recurring Event:** Runs repeatedly at a set interval.

### Example 1: One-Time Event (Run Once)
Let's drop a temporary promotional table exactly at midnight on New Year's Eve.

```sql
CREATE EVENT drop_promo_table
ON SCHEDULE AT '2024-12-31 23:59:59'
DO
    DROP TABLE IF EXISTS HolidayPromo2024;
```

### Example 2: Recurring Event (Run Every interval)
Let's say we have an `ErrorLogs` table that gets massive. We want to automatically delete logs older than 30 days, every single night at 3:00 AM.

```sql
CREATE EVENT purge_old_logs
ON SCHEDULE EVERY 1 DAY STARTS '2023-11-01 03:00:00'
DO
    DELETE FROM ErrorLogs WHERE LogDate < NOW() - INTERVAL 30 DAY;
```

---

## 3. Complex Events (Using BEGIN / END)

Just like Stored Procedures, if you need your event to execute multiple SQL statements, you must wrap them in a `BEGIN ... END` block and change the `DELIMITER`.

### Example 3: Daily Analytics Rollup
Running massive `SUM()` and `COUNT()` queries on a 50-million-row `Orders` table during peak business hours will crash the server. Instead, we can schedule an event to calculate yesterday's totals at 1:00 AM, and save the result into a small, fast `DailyStats` table.

```sql
DELIMITER //

CREATE EVENT generate_daily_stats
ON SCHEDULE EVERY 1 DAY STARTS '2023-11-01 01:00:00'
DO
BEGIN
    DECLARE yesterday DATE;
    SET yesterday = CURDATE() - INTERVAL 1 DAY;

    INSERT INTO DailyStats (StatDate, TotalRevenue, TotalOrders)
    SELECT 
        yesterday,
        SUM(TotalAmount),
        COUNT(OrderID)
    FROM Orders
    WHERE DATE(OrderDate) = yesterday;
END //

DELIMITER ;
```

---

## 4. Managing Events

You can view, alter, or disable events at any time.

```sql
-- View all currently scheduled events
SHOW EVENTS;

-- Temporarily disable an event without deleting it
ALTER EVENT purge_old_logs DISABLE;

-- Re-enable it
ALTER EVENT purge_old_logs ENABLE;

-- Permanently delete an event
DROP EVENT IF EXISTS purge_old_logs;
```

---

## 5. When to use DB Events vs Application CRON Jobs

**Use MySQL Events when:**
*   The task is 100% database-related (e.g., purging old records, recalculating summary tables, rebuilding indexes).
*   You don't want to rely on an external server or application to be online to trigger DB maintenance.

**Use Application CRON Jobs (Python/Node.js) when:**
*   The task requires interacting with the outside world (e.g., "Find all overdue users and make an API call to SendGrid to email them"). The database cannot (and should not) make HTTP network calls!
