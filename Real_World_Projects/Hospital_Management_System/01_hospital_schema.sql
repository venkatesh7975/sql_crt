-- ====================================================================
-- HOSPITAL MANAGEMENT SYSTEM SCHEMA & SAMPLE DATA
-- MySQL 8.0 Compliant
-- ====================================================================

CREATE DATABASE IF NOT EXISTS HospitalDB;
USE HospitalDB;

-- --------------------------------------------------------------------
-- 1. DDL: Table Definitions
-- --------------------------------------------------------------------

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100)
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(100) NOT NULL,
    DepartmentID INT,
    HireDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Patients Table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('M', 'F', 'Other') NOT NULL,
    PhoneNumber VARCHAR(20),
    BloodType VARCHAR(5)
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- MedicalRecords Table
CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    Diagnosis VARCHAR(255) NOT NULL,
    Prescription TEXT,
    VisitDate DATE NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Billing Table
CREATE TABLE Billing (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus ENUM('Unpaid', 'Partial', 'Paid') DEFAULT 'Unpaid',
    BillingDate DATE NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE SET NULL
);

-- --------------------------------------------------------------------
-- 2. DML: Sample Data Injection
-- --------------------------------------------------------------------

-- Insert Departments
INSERT INTO Departments (DepartmentName, Location) VALUES
('Cardiology', 'Building A - Floor 2'),
('Neurology', 'Building A - Floor 3'),
('Pediatrics', 'Building B - Floor 1'),
('Orthopedics', 'Building B - Floor 2'),
('Emergency', 'Main Floor - ER');

-- Insert Doctors
INSERT INTO Doctors (FirstName, LastName, Specialty, DepartmentID, HireDate) VALUES
('Gregory', 'House', 'Diagnostician', 2, '2015-05-12'),
('Meredith', 'Grey', 'General Surgery', 5, '2018-09-01'),
('John', 'Carter', 'Emergency Medicine', 5, '2020-01-15'),
('Allison', 'Cameron', 'Immunology', 3, '2016-11-20');

-- Insert Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, PhoneNumber, BloodType) VALUES
('Walter', 'White', '1958-09-07', 'M', '555-1010', 'O+'),
('Tony', 'Soprano', '1959-08-22', 'M', '555-2020', 'AB-'),
('Leslie', 'Knope', '1975-01-18', 'F', '555-3030', 'A+'),
('Arya', 'Stark', '2005-04-15', 'F', '555-4040', 'O-');

-- Insert Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1, 1, '2023-11-01 09:00:00', 'Completed'),
(2, 3, '2023-11-02 10:30:00', 'Completed'),
(3, 4, '2023-11-05 14:00:00', 'Scheduled'),
(4, 2, '2023-11-10 11:15:00', 'Cancelled');

-- Insert MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, Diagnosis, Prescription, VisitDate) VALUES
(1, 1, 'Lung Cancer', 'Chemotherapy Schedule A', '2023-11-01'),
(2, 3, 'Panic Attack', 'Prozac 20mg', '2023-11-02');

-- Insert Billing
INSERT INTO Billing (PatientID, AppointmentID, TotalAmount, PaymentStatus, BillingDate) VALUES
(1, 1, 1500.00, 'Unpaid', '2023-11-01'),
(2, 2, 450.00, 'Paid', '2023-11-02');
