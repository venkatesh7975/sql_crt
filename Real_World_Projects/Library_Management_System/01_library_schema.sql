-- ====================================================================
-- LIBRARY MANAGEMENT SYSTEM SCHEMA & SAMPLE DATA
-- MySQL 8.0 Compliant
-- ====================================================================

CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- --------------------------------------------------------------------
-- 1. DDL: Table Definitions
-- --------------------------------------------------------------------

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Bio TEXT
);

-- Publishers Table
CREATE TABLE Publishers (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE,
    ContactEmail VARCHAR(100)
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title VARCHAR(255) NOT NULL,
    PublisherID INT,
    PublicationYear INT,
    Genre VARCHAR(50),
    TotalCopies INT NOT NULL DEFAULT 1,
    AvailableCopies INT NOT NULL DEFAULT 1,
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

-- BookAuthors (Junction Table for M:N relationship)
CREATE TABLE BookAuthors (
    BookID INT NOT NULL,
    AuthorID INT NOT NULL,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE
);

-- Members Table
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    MembershipDate DATE NOT NULL,
    Status ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active'
);

-- Loans Table (Checkout History)
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    CheckoutDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status ENUM('Checked Out', 'Returned', 'Overdue', 'Lost') DEFAULT 'Checked Out',
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Fines Table
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    LoanID INT NOT NULL,
    Amount DECIMAL(6,2) NOT NULL,
    Reason VARCHAR(255),
    Paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- --------------------------------------------------------------------
-- 2. DML: Sample Data Injection
-- --------------------------------------------------------------------

-- Insert Authors
INSERT INTO Authors (FirstName, LastName) VALUES
('J.K.', 'Rowling'),
('George R.R.', 'Martin'),
('J.R.R.', 'Tolkien'),
('Brandon', 'Sanderson');

-- Insert Publishers
INSERT INTO Publishers (PublisherName, ContactEmail) VALUES
('Bloomsbury', 'contact@bloomsbury.com'),
('Bantam Books', 'info@bantambooks.com'),
('Tor Books', 'tor@torbooks.com');

-- Insert Books
INSERT INTO Books (ISBN, Title, PublisherID, PublicationYear, Genre, TotalCopies, AvailableCopies) VALUES
('978-0439708180', 'Harry Potter and the Sorcerers Stone', 1, 1997, 'Fantasy', 5, 3),
('978-0553103540', 'A Game of Thrones', 2, 1996, 'Fantasy', 3, 3),
('978-0618260224', 'The Fellowship of the Ring', 1, 1954, 'High Fantasy', 4, 0),
('978-0765326355', 'The Way of Kings', 3, 2010, 'Epic Fantasy', 2, 2);

-- Insert BookAuthors
INSERT INTO BookAuthors (BookID, AuthorID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insert Members
INSERT INTO Members (FirstName, LastName, Email, MembershipDate) VALUES
('Bruce', 'Wayne', 'bruce@wayneenterprises.com', '2023-01-15'),
('Clark', 'Kent', 'clark@dailyplanet.com', '2023-02-20'),
('Diana', 'Prince', 'diana@themyscira.gov', '2023-03-10');

-- Insert Loans
-- Note: Fellowship of the Ring (Book 3) has 0 available copies, so we check out all 4.
INSERT INTO Loans (BookID, MemberID, CheckoutDate, DueDate, ReturnDate, Status) VALUES
(1, 1, '2023-10-01', '2023-10-15', '2023-10-12', 'Returned'),
(1, 2, '2023-10-20', '2023-11-04', NULL, 'Checked Out'),
(3, 1, '2023-09-01', '2023-09-15', NULL, 'Overdue'),
(3, 2, '2023-10-25', '2023-11-09', NULL, 'Checked Out'),
(3, 3, '2023-10-26', '2023-11-10', NULL, 'Checked Out');

-- Insert Fines
INSERT INTO Fines (LoanID, Amount, Reason, Paid) VALUES
(3, 15.00, 'Overdue by 45+ days', FALSE);
