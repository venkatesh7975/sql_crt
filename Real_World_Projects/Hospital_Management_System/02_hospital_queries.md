# Hospital Management System: Real-World Reporting Queries

This document contains 10 realistic BI and operational queries commonly requested by Hospital Administrators and Medical Directors.

---

### 1. Daily Appointment Roster
**Scenario:** The reception desk needs a list of all patients coming in "today" along with the doctor they are seeing.
```sql
SELECT 
    a.AppointmentDate,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    CONCAT('Dr. ', d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialty
FROM Appointments a
INNER JOIN Patients p ON a.PatientID = p.PatientID
INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE DATE(a.AppointmentDate) = CURRENT_DATE()
AND a.Status = 'Scheduled'
ORDER BY a.AppointmentDate ASC;
```

### 2. Department Workload (Doctor Count)
**Scenario:** HR needs to know how many doctors are staffed in each department to identify hiring shortages.
```sql
SELECT 
    dep.DepartmentName,
    COUNT(doc.DoctorID) AS NumberOfDoctors
FROM Departments dep
LEFT JOIN Doctors doc ON dep.DepartmentID = doc.DepartmentID
GROUP BY dep.DepartmentID, dep.DepartmentName
ORDER BY NumberOfDoctors ASC;
```

### 3. Patient Medical History Lookup
**Scenario:** A doctor requests the complete medical history of a specific patient (e.g., Walter White).
```sql
SELECT 
    mr.VisitDate,
    CONCAT('Dr. ', d.LastName) AS SeenBy,
    mr.Diagnosis,
    mr.Prescription
FROM MedicalRecords mr
INNER JOIN Doctors d ON mr.DoctorID = d.DoctorID
INNER JOIN Patients p ON mr.PatientID = p.PatientID
WHERE p.FirstName = 'Walter' AND p.LastName = 'White'
ORDER BY mr.VisitDate DESC;
```

### 4. Patient Demographics (Age Calculation)
**Scenario:** Research department needs to calculate the current age of all patients based on their DOB.
```sql
SELECT 
    FirstName, 
    LastName, 
    DateOfBirth,
    TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS CurrentAge
FROM Patients
ORDER BY CurrentAge DESC;
```

### 5. Financial Dashboard: Unpaid Bills
**Scenario:** The billing department needs a list of all unpaid or partially paid bills to send collections notices.
```sql
SELECT 
    b.BillID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.PhoneNumber,
    b.TotalAmount,
    b.BillingDate
FROM Billing b
INNER JOIN Patients p ON b.PatientID = p.PatientID
WHERE b.PaymentStatus != 'Paid'
ORDER BY b.TotalAmount DESC;
```

### 6. Doctor Appointment Completion Rate
**Scenario:** Hospital administration wants to track how many appointments each doctor successfully completes vs cancellations.
```sql
SELECT 
    CONCAT('Dr. ', d.LastName) AS DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedAppointments,
    SUM(CASE WHEN a.Status IN ('Cancelled', 'No-Show') THEN 1 ELSE 0 END) AS MissedAppointments
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.LastName;
```

### 7. Most Common Diagnoses
**Scenario:** Public health reporting needs to know the most frequent diagnoses given at the hospital.
```sql
SELECT 
    Diagnosis,
    COUNT(RecordID) AS Frequency
FROM MedicalRecords
GROUP BY Diagnosis
ORDER BY Frequency DESC
LIMIT 10;
```

### 8. Blood Type Inventory Needs
**Scenario:** The blood bank wants to know the distribution of blood types across registered patients.
```sql
SELECT 
    BloodType,
    COUNT(PatientID) AS NumberOfPatients
FROM Patients
WHERE BloodType IS NOT NULL
GROUP BY BloodType
ORDER BY NumberOfPatients DESC;
```

### 9. Monthly Revenue by Department
**Scenario:** The CFO needs to see which departments are generating the most revenue.
```sql
SELECT 
    dep.DepartmentName,
    SUM(b.TotalAmount) AS TotalBilled
FROM Billing b
INNER JOIN Appointments a ON b.AppointmentID = a.AppointmentID
INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
INNER JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
GROUP BY dep.DepartmentID, dep.DepartmentName
ORDER BY TotalBilled DESC;
```

### 10. Identify Frequent Flyers (High Visit Patients)
**Scenario:** Identify patients who have visited the hospital more than 5 times this year to enroll them in case management.
```sql
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    COUNT(a.AppointmentID) AS TotalVisits
FROM Patients p
INNER JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.Status = 'Completed' 
AND YEAR(a.AppointmentDate) = YEAR(CURDATE())
GROUP BY p.PatientID, p.FirstName, p.LastName
HAVING TotalVisits > 5
ORDER BY TotalVisits DESC;
```
