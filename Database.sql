-- Database.sql
CREATE DATABASE IF NOT EXISTS `deepsight_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `deepsight_db`;

DROP TABLE IF EXISTS Diagnoses;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

CREATE TABLE Doctors (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  Doctor_ID VARCHAR(20) UNIQUE NOT NULL,
  Doctor_Name VARCHAR(100) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Specialization VARCHAR(50) NOT NULL,
  Phone_Num VARCHAR(15),
  Email VARCHAR(100),
  Experience INT,
  Hospital VARCHAR(100),
  Profile_Image VARCHAR(300)
);

ALTER TABLE Doctors
  ADD INDEX idx_doctor_name (Doctor_Name);

CREATE TABLE Patients (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  Patient_ID VARCHAR(20) UNIQUE NOT NULL,
  Patient_Name VARCHAR(100) NOT NULL,
  Gender VARCHAR(10) NOT NULL,
  Date_Of_Birth DATE NOT NULL
);

CREATE TABLE Diagnoses (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  Patient_Name VARCHAR(100) NOT NULL,
  Patient_ID VARCHAR(20)  NOT NULL,
  Doctor_Name VARCHAR(100) NOT NULL,
  Date_Of_Scan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Diagnosis_Result VARCHAR(200),
  FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
  FOREIGN KEY (Doctor_Name) REFERENCES Doctors(Doctor_Name)
);


ALTER TABLE Diagnoses ADD COLUMN Report_File VARCHAR(255);

-- Replace the email address with your own email to receive OTP codes
-- Insert unique Doctors data 
INSERT INTO Doctors (Doctor_ID, Doctor_Name, Password, Specialization, Phone_Num, Email, Experience, Hospital) VALUES
('D0001', 'Dr.Sara Saud', 'pass001', 'Ophthalmology', '0500000000', 'doctor@example.com', 10, 'King Khalid Eye Hospital');