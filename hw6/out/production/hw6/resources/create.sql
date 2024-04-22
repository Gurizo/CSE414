DROP TABLE IF EXISTS [dbo].[Availabilities]
DROP TABLE IF EXISTS [dbo].[Caregivers]
DROP TABLE IF EXISTS [dbo].[Vaccines]
DROP TABLE IF EXISTS Reserves
DROP TABLE IF EXISTS Appointments
DROP TABLE IF EXISTS Patients

CREATE TABLE Caregivers (
    Username varchar(255),
    Salt BINARY(16),
    Hash BINARY(16),
    PRIMARY KEY (Username)
);

CREATE TABLE Patients (
    Username varchar(255),
    Salt BINARY(16),
    Hash BINARY(16),
    PRIMARY KEY (Username)
);

CREATE TABLE Appointments (
    AppointmentID int PRIMARY KEY
);

CREATE TABLE Vaccines (
    Name varchar(255),
    Doses int,
    PRIMARY KEY (Name),
    AppointmentID int FOREIGN KEY REFERENCES Appointments(AppointmentID) -- uses
);

CREATE TABLE Availabilities (
    Time date,
    Username varchar(255) REFERENCES Caregivers, --Have
    PRIMARY KEY (Time, Username)
);

CREATE TABLE Reserves ( --one caregivers to one appointment
    Username varchar(255)
        UNIQUE REFERENCES Patients,
    AppointmentID int
        UNIQUE REFERENCES Appointments
);

CREATE TABLE IsCheckedBy ( --one appointment to one availability
    Time date,
    Username varchar(255),
    AppointmentID int UNIQUE REFERENCES Appointments,
    PRIMARY KEY (Time, Username),
    FOREIGN KEY (Time, Username) REFERENCES Availabilities(Time, Username),
    UNIQUE (Time, Username) -- Adding a unique constraint
);
