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
- [License](#license)

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

