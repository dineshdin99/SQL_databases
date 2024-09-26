--Creating database
CREATE DATABASE HOSPITAL;

--using database
USE HOSPITAL;

--checking database for tables
SELECT * FROM Appointment;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Appointment';

SELECT * FROM Doctors;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Doctors';

SELECT * FROM Medical_History;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Medical_History';

SELECT * FROM Medication_Cost;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Medication_Cost';

SELECT * FROM Patient_Attendence;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patient_Attendence';

SELECT * FROM Patient_History;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patient_History';

SELECT * FROM Patients;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patients';

--Appointment Table Modification
ALTER TABLE Appointment
ALTER COLUMN PatientID SMALLINT;

ALTER TABLE Appointment
ALTER COLUMN AppointmentID char(5);

ALTER TABLE Appointment
ALTER COLUMN DoctorID SMALLINT;

--checking databses for tables
SELECT * FROM Doctors;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Doctors';

--Doctor table modification
ALTER TABLE Doctors
ALTER COLUMN DoctorID SMALLINT;

--checking databses for tables
SELECT * FROM Medical_History;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Medical_History';

--Medical_History Modification
ALTER TABLE Medical_History
ALTER COLUMN HistoryID char(5);

ALTER TABLE Medical_History
ALTER COLUMN PatientID SMALLINT;

--Medication_Cost table 
CREATE TABLE Medication_Cost
(Medication VARCHAR(10),Cost_in_$ SMALLINT);

INSERT INTO Medication_Cost
VALUES('Lisinopril',10),
      ('Metformin',15),
      ('Albuterol',12),
      ('Ibuprofen',8),
      ('Insulin',20);

--checking databses for tables
SELECT * FROM Patient_Attendence;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patient_Attendence';

--Patient_Attendence table modifications
ALTER TABLE Patient_Attendence
ALTER COLUMN AppointmentID char(5);

ALTER TABLE Patient_Attendence
ALTER COLUMN PatientID SMALLINT;

--checking databses for tables
SELECT * FROM Patient_History;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patient_History';

--Patient_History table modifications
ALTER TABLE Patient_History
ALTER COLUMN HistoryID char(5);

ALTER TABLE Patient_History
ALTER COLUMN PatientID SMALLINT;

ALTER TABLE Patients
ALTER COLUMN Contact INT;

ALTER TABLE Patients
ALTER COLUMN Contact VARCHAR(15); 

-- First, clean the data by removing non-numeric characters
UPDATE Patients
SET Contact = REPLACE(REPLACE(REPLACE(Contact, '-', ''), '(', ''), ')', '');

ALTER TABLE Patients
ALTER COLUMN PatientID SMALLINT;

-- Then, alter the column to BIGINT
ALTER TABLE Patients
ALTER COLUMN Contact BIGINT;

--PRIMARY KEYS

--assigning primary key and putting notnull constraint
ALTER TABLE Patients
ALTER COLUMN PatientID SMALLINT NOT NULL;

ALTER TABLE Patients
ADD CONSTRAINT PK_Patients PRIMARY KEY (PatientID);

--assigning primary key and putting notnull constraint
ALTER TABLE Doctors
ALTER COLUMN DoctorID SMALLINT NOT NULL;

ALTER TABLE Doctors
ADD CONSTRAINT PK_Doctors PRIMARY KEY (DoctorID);

--assigning primary key and putting notnull constraint
ALTER TABLE Appointment
ALTER COLUMN AppointmentID CHAR(5) NOT NULL;

ALTER TABLE Appointment
ALTER COLUMN PatientID NOT NULL;

ALTER TABLE Appointment
ADD CONSTRAINT PK_Appointment PRIMARY KEY (AppointmentID,PatientID);

ALTER TABLE Patient_Attendence
ALTER COLUMN PatientID SMALLINT NOT NULL;

ALTER TABLE Patient_Attendence
ALTER COLUMN AppointmentID CHAR(5) NOT NULL;

ALTER TABLE Medical_History
ALTER COLUMN HistoryID CHAR(5) NOT NULL;

ALTER TABLE Medical_History
ALTER COLUMN PatientID SMALLINT NOT NULL;

ALTER TABLE Medical_History
ADD CONSTRAINT PK_Medical_History PRIMARY KEY (HistoryID,PatientID);

ALTER TABLE Medication_Cost
ALTER COLUMN Medication VARCHAR(15) NOT NULL;

ALTER TABLE Medication_Cost
ADD CONSTRAINT PK_Medication_Cost PRIMARY KEY (Medication);

ALTER TABLE Patient_History
ALTER COLUMN PatientID SMALLINT NOT NULL;

ALTER TABLE Patient_History
ALTER COLUMN HistoryID CHAR(5) NOT NULL;

ALTER TABLE Patient_History
ADD CONSTRAINT PK_Patient_History PRIMARY KEY (PatientID,HistoryID);

--FOREIGN KEYS
ALTER TABLE Appointment
ADD CONSTRAINT FK_Appointment_Patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);

ALTER TABLE Appointment
ADD CONSTRAINT FK_Appointment_Doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);

ALTER TABLE Patient_Attendence
ADD CONSTRAINT FK_Patient_Attendance_Patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);

ALTER TABLE Patient_Attendence
ADD CONSTRAINT FK_Patient_Attendance_Appointment FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID);

ALTER TABLE Medical_History
ADD CONSTRAINT FK_Medical_History_Patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);

ALTER TABLE Medical_History
ADD CONSTRAINT FK_Medical_Fill_History_Patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)

/*ALTER TABLE Medical_History
ADD CONSTRAINT FK_Medical_Fill_History_History FOREIGN KEY (HistoryID) REFERENCES Patient_History(HistoryID);*/



--Unique keys
ALTER TABLE Doctors
ADD CONSTRAINT UQ_Doctor_Contact_Email UNIQUE (contactEmail);

ALTER TABLE Patients
ADD CONSTRAINT UQ_Patient_Contact UNIQUE (Contact);

ALTER TABLE Appointment
ADD CONSTRAINT UQ_Appointment_AppointmentID UNIQUE (AppointmentID);

SELECT * FROM Patients;

SELECT * FROM Patient_Attendence

SELECT * FROM Appointment

SELECT * FROM Doctors

SELECT * FROM Medical_History

SELECT * FROM Medication_Cost

SELECT* FROM Patient_History

--ANALYSIS
-----------------------------------------------------------------------------------------------------------------------------------

--1. Find the names of patients who have attended appointments scheduled by Dr. John Doe.
SELECT P.PatientID,P.Fname AS PatientFirstName, P.Lname AS PatientLastName
FROM Patients P
JOIN Patient_Attendence PA ON P.PatientID = PA.PatientID
JOIN Appointment A ON PA.AppointmentID = A.AppointmentID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE D.DoctorID = 1;


--2. Calculate the average age of all patients.
SELECT AVG(Age) AS Average_Age
FROM Patients;
--Average age of patients is 37

--3. Create a stored procedure to get the total number of appointments for a given patient.
CREATE PROCEDURE GetTotalAppointments (@PatientID INT)
AS
BEGIN
    SELECT COUNT(*) AS Total_Appointments
    FROM Appointment
    WHERE PatientID = @PatientID;
END;

EXEC GetTotalAppointments @PatientID = 10;

--4. Create a trigger to update the appointment status to 'Completed' when the appointment date has passed.
CREATE TRIGGER UpdateAppointmentStatus
ON Appointment
AFTER UPDATE
AS
BEGIN
    UPDATE Appointment
    SET Status = 'Completed'
    WHERE Date < GETDATE() AND Status != 'Completed';
END;

--5. Find the names of patients along with their appointment details and the corresponding doctor's name.
SELECT P.Fname AS Patient_FirstName, P.Lname AS Patient_LastName, 
       A.Date AS Appointment_Date, A.Endtime AS Appointment_EndTime, 
       D.Fname AS Doctor_FirstName, D.Lname AS Doctor_LastName
FROM Patients P
JOIN Appointment A ON P.PatientID = A.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID;

--6. Find the patients who have a medical history of diabetes and their next appointment is scheduled within the next 7 days.
-- Define the date range for the next 7 days

-- Query to find patients with diabetes and schedule their next appointment
SELECT P.Fname, P.Lname, MH.Date AS ExistingAppointmentDate,MH.condition,
       DATEADD(DAY, 7, MH.Date) AS SuggestedNextAppointmentDate
FROM Medical_History MH
JOIN Patients P ON MH.PatientID = P.PatientID
WHERE MH.Condition = 'Diabetes';

--7. Find patients who have multiple appointments scheduled.
SELECT P.Fname, P.Lname, COUNT(PA.AppointmentID) AS Total_Appointments
FROM Patients P
JOIN Patient_Attendence PA ON P.PatientID = PA.PatientID
GROUP BY P.PatientID, P.Fname, P.Lname
HAVING COUNT(PA.AppointmentID) > 1;

--8.Calculate the average duration of appointments for each doctor.
SELECT D.Fname, D.Lname, AVG(DATEDIFF(MINUTE, A.Date, A.Endtime)) AS Avg_Appointment_Duration
FROM Appointment A
JOIN Doctors D ON A.DoctorID = D.DoctorID
GROUP BY D.DoctorID, D.Fname, D.Lname;

UPDATE Appointment SET EndTime = '2023-11-09 13:21:00.0000000'
WHERE EndTime = '2023-11-09 01:21:00.0000000';


--9.Find Patients with Most Appointments.
SELECT P.Fname, P.Lname, COUNT(PA.AppointmentID) AS Appointment_Count
FROM Patients P
JOIN Patient_Attendence PA ON P.PatientID = PA.PatientID
GROUP BY P.PatientID, P.Fname, P.Lname
ORDER BY Appointment_Count DESC;

--10. Calculate the total cost of medication for each patient.
SELECT P.Fname, P.Lname, SUM(MC.Cost_in_$) AS Total_Medication_Cost
FROM Patients P
JOIN Medical_History MH ON P.PatientID = MH.PatientID
JOIN Medication_Cost MC ON MH.Medication = MC.Medication
GROUP BY P.PatientID, P.Fname, P.Lname;

--11.Create a stored procedure named CalculatePatientBill that calculates the total bill for a patient.

CREATE PROCEDURE CalculatePatientBill
    @PatientID INT
AS
BEGIN
    -- Declare a variable to hold the total cost
    DECLARE @TotalBill DECIMAL(10, 2);

    -- Calculate the total cost of medications for the patient
    -- and sum up the cost for each medication
    DECLARE @MedicationCost DECIMAL(10, 2);
    
    SELECT @MedicationCost = ISNULL(SUM(MC.cost_in_$), 0)
    FROM Medical_History MH
    JOIN Medical_History MFH ON MH.HistoryID = MFH.HistoryID
    JOIN Medication_Cost MC ON MFH.Medication = MC.Medication
    WHERE MH.PatientID = @PatientID;
    
    -- Calculate the number of surgeries and apply $50 charge per surgery
    DECLARE @SurgeryCount INT;
    SELECT @SurgeryCount = ISNULL(COUNT(*), 0)
    FROM Medical_History
    WHERE PatientID = @PatientID
    AND Surgeries IS NOT NULL
    AND Surgeries <> '';
    
    -- Calculate total bill
    SET @TotalBill = @MedicationCost + (@SurgeryCount * 50);

    -- If no medical history, ensure a minimum charge of $50
    IF @TotalBill = 0
    BEGIN
        SET @TotalBill = 50;
    END

    -- Return the total bill
    SELECT @TotalBill AS TotalBill;
END;

EXEC CalculatePatientBill @PatientID = 1;

EXEC CalculatePatientBill @PatientID = 2;

EXEC CalculatePatientBill @PatientID = 3;

EXEC CalculatePatientBill @PatientID = 4;

EXEC CalculatePatientBill @PatientID = 5;

EXEC CalculatePatientBill @PatientID = 6;

EXEC CalculatePatientBill @PatientID = 7;

EXEC CalculatePatientBill @PatientID = 8;

EXEC CalculatePatientBill @PatientID = 9;

EXEC CalculatePatientBill @PatientID = 10;











SELECT * FROM Medication_Cost

ALTER TABLE Medication_Cost
ADD Cost_In_$ MONEY;

update Medication_Cost set Cost_In_$ = '$12'
where 'Albuterol' IS Null

DROP TABLE Medication_Cost;

CREATE TABLE Medication_Cost
(Medication VARCHAR(15), Cost_In_$ MONEY);

INSERT INTO Medication_Cost
VALUES('Albuterol','$12'),
      ('Ibuprofen','$8'),
	  ('Insulin','$20'),
	  ('Lisinopril','$10'),
	  ('Metformin','$15');

UPDATE Medication_Cost
SET Cost_in_$ = FORMAT(CAST(Cost_in_$ AS MONEY), 'C', 'en-US');

ALTER TABLE Patient_Attendence
ALTER COLUMN PatientID SMALLINT;

ALTER TABLE Patients
ALTER COLUMN PatientID SMALLINT;

SELECT * FROM Patient_Attendence;

ALTER TABLE Doctors
ALTER COLUMN DoctorID SMALLINT;