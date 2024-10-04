# Hospital Database Management System (HMS) 🏥

The **Hospital Database Management System (HMS)** is designed to streamline healthcare operations by managing patient data, doctor records, appointments, medical history, and medication costs. It leverages SQL for database management, ensuring smooth data handling and retrieval processes across various hospital departments.

## Table of Contents
- [About the Project](#about-the-project)
- [Features](#features)
- [Database Structure](#database-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Queries](#queries)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)

## About the Project

The **Hospital Database Management System** focuses on simplifying and automating key healthcare operations such as patient record management, doctor scheduling, appointment booking, and medical billing. This system connects various hospital departments with an efficient, secure, and structured database.

## Features
- Manage patient and doctor records.
- Schedule and track appointments.
- Maintain medical history (surgeries, conditions, medications).
- Calculate patient bills based on medication and surgery history.
- Generate reports for hospital administration.

## Database Structure
The project consists of the following tables:

- **Patients**: Stores patient details such as `PatientID`, `Fname`, `Lname`, `Contact`, and `Age`.
- **Doctors**: Stores doctor information like `DoctorID`, `Fname`, `Lname`, `Speciality`, and `contact_email`.
- **Appointment**: Tracks appointments with columns `AppointmentID`, `PatientID`, `DoctorID`, `Date`, `Endtime`, and `Status`.
- **Medical_History**: Records the medical history of patients including `Conditions`, `Surgery`, and `Medication`.
- **Patient_Attendence_Appointment**: Tracks patient attendance for appointments.
- **Medication_Cost**: Contains medication costs.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/hospital-database-management.git
    ```sql
   SELECT P.Fname, P.Lname
   FROM Patients P
   JOIN Appointment A ON P.PatientID = A.PatientID
   JOIN Doctors D ON A.DoctorID = D.DoctorID
   WHERE D.Fname = 'John' AND D.Lname = 'Doe';
        ```bash
      SELECT D.Fname, D.Lname, AVG(DATEDIFF(MINUTE, A.Date, A.Endtime)) AS Avg_Appointment_Duration
      FROM Appointment A
      JOIN Doctors D ON A.DoctorID = D.DoctorID
      GROUP BY D.DoctorID, D.Fname, D.Lname;

## Technologies Used
- SQL Server: Used for database design and query management.
-T-SQL: Used for creating stored procedures, triggers, and complex queries.
-Git: For version control and project collaboration.

## Contributing
-->Contributions are welcome! Please follow these steps to contribute:

-Fork the repository.
-Create a feature branch: git checkout -b feature-name.
-Commit your changes: git commit -m 'Add some feature'.
-Push to the branch: git push origin feature-name.
-Open a pull request.

