# Library Management System: Real-World Reporting Queries

This document contains 10 realistic BI and operational queries commonly requested by Head Librarians.

---

### 1. Find all Books by a Specific Author
**Scenario:** A patron walks in and asks to see all books written by 'J.K. Rowling'.
```sql
SELECT 
    b.Title, 
    b.PublicationYear, 
    b.Genre, 
    b.AvailableCopies
FROM Books b
INNER JOIN BookAuthors ba ON b.BookID = ba.BookID
INNER JOIN Authors a ON ba.AuthorID = a.AuthorID
WHERE a.FirstName = 'J.K.' AND a.LastName = 'Rowling';
```

### 2. Check Book Availability by Title
**Scenario:** A patron is searching the catalog for a specific book.
```sql
SELECT 
    Title, 
    TotalCopies, 
    AvailableCopies,
    CASE 
        WHEN AvailableCopies > 0 THEN 'Available'
        ELSE 'Currently Checked Out'
    END AS Status
FROM Books
WHERE Title LIKE '%Fellowship%';
```

### 3. List of Overdue Books
**Scenario:** The automated system needs a list of all currently overdue books to send reminder emails to members.
```sql
SELECT 
    m.FirstName,
    m.LastName,
    m.Email,
    b.Title,
    l.DueDate,
    DATEDIFF(CURDATE(), l.DueDate) AS DaysOverdue
FROM Loans l
INNER JOIN Members m ON l.MemberID = m.MemberID
INNER JOIN Books b ON l.BookID = b.BookID
WHERE l.Status = 'Overdue' 
   OR (l.Status = 'Checked Out' AND l.DueDate < CURDATE());
```

### 4. Top 5 Most Popular Books (Most Checkouts)
**Scenario:** The library wants to buy more copies of highly demanded books.
```sql
SELECT 
    b.Title,
    COUNT(l.LoanID) AS CheckoutCount
FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
GROUP BY b.BookID, b.Title
ORDER BY CheckoutCount DESC
LIMIT 5;
```

### 5. Member Fine Ledger (Unpaid Fines)
**Scenario:** A member is trying to check out a new book. The librarian needs to see if they have any unpaid fines blocking their account.
```sql
SELECT 
    m.FirstName,
    m.LastName,
    SUM(f.Amount) AS TotalUnpaidFines
FROM Members m
INNER JOIN Loans l ON m.MemberID = l.MemberID
INNER JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.Paid = FALSE
GROUP BY m.MemberID, m.FirstName, m.LastName
HAVING TotalUnpaidFines > 0;
```

### 6. Books that have NEVER been checked out
**Scenario:** The library is running out of shelf space and wants to donate dead inventory.
```sql
SELECT 
    b.ISBN, 
    b.Title, 
    b.PublicationYear
FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;
```

### 7. Currently Checked Out Books per Member
**Scenario:** A member wants to know what books they currently have checked out and when they are due.
```sql
SELECT 
    b.Title,
    l.CheckoutDate,
    l.DueDate
FROM Loans l
INNER JOIN Books b ON l.BookID = b.BookID
INNER JOIN Members m ON l.MemberID = m.MemberID
WHERE m.Email = 'bruce@wayneenterprises.com'
  AND l.Status IN ('Checked Out', 'Overdue');
```

### 8. Total Inventory Value/Count per Publisher
**Scenario:** The procurement team needs a report on how many books come from each publisher.
```sql
SELECT 
    p.PublisherName,
    SUM(b.TotalCopies) AS TotalBooksInSystem,
    COUNT(DISTINCT b.BookID) AS UniqueTitles
FROM Publishers p
LEFT JOIN Books b ON p.PublisherID = b.PublisherID
GROUP BY p.PublisherID, p.PublisherName
ORDER BY TotalBooksInSystem DESC;
```

### 9. Safely Handle a Book Return (Transaction)
**Scenario:** A book is returned. You need to update the Loan record AND increment the AvailableCopies count. This must be wrapped in a transaction.
```sql
BEGIN;
    -- 1. Mark the loan as returned
    UPDATE Loans 
    SET Status = 'Returned', ReturnDate = CURDATE() 
    WHERE LoanID = 2; -- Assuming LoanID 2 is being returned

    -- 2. Increment the available copies for that book
    UPDATE Books 
    SET AvailableCopies = AvailableCopies + 1 
    WHERE BookID = (SELECT BookID FROM Loans WHERE LoanID = 2);
COMMIT;
```

### 10. Members with Expired/Suspended Accounts
**Scenario:** Generate a report of all accounts that are not in good standing.
```sql
SELECT 
    FirstName, 
    LastName, 
    Email, 
    Status 
FROM Members
WHERE Status != 'Active';
```
