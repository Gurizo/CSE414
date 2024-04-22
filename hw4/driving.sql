DROP TABLE IF EXISTS Drives;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Truck;
DROP TABLE IF EXISTS NonProfessionalDriver;
DROP TABLE IF EXISTS ProfessionalDriver;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS InsuranceCo;
DROP TABLE IF EXISTS Person;

CREATE TABLE Person ( 
    ssn int PRIMARY KEY, 
    name varchar(30)      
    );
         
CREATE TABLE Driver (
    ssn int PRIMARY KEY REFERENCES Person,
    driverID int 
    );

CREATE TABLE InsuranceCo (
    name varchar(30) PRIMARY KEY, 
    phone int
    );

CREATE TABLE Vehicle (
    licensePlate varchar(10) PRIMARY KEY, 
    year int,
    maxLiability REAL,
    ssn int FOREIGN KEY REFERENCES Person(ssn), --owns
    name varchar(30) FOREIGN KEY REFERENCES InsuranceCo(name) --insures
    );

CREATE TABLE NonProfessionalDriver (
    ssn int PRIMARY KEY REFERENCES Driver 
    );

CREATE TABLE ProfessionalDriver (
    ssn int PRIMARY KEY REFERENCES Driver,
    medicalHistory varchar(30)
    );

CREATE TABLE Car (
    licensePlate varchar(10) PRIMARY KEY REFERENCES Vehicle,
    make varchar(30),
    );

CREATE TABLE Truck (
    licensePlate varchar(10) PRIMARY KEY REFERENCES Vehicle,
    capacity varchar(30),
    ssn int FOREIGN KEY REFERENCES ProfessionalDriver(ssn) --operates
    );

CREATE TABLE Drives (
    licensePlate varchar(10) REFERENCES Car,
    ssn int REFERENCES NonProfessionalDriver,
    PRIMARY KEY (licensePlate, ssn)
    );

-- b. (5 points) Which relation in your relational schema represents the relationship "insures" in the E/R diagram? Why is that your representation?
-- The "name" from the Vehicle represents the relationship "insures." As there could be only one insurance company for vehicles, I decided to make the vehicle to
-- refer to the name of the insurance company so that many(vehicle) to one(insurance company) relationship satisfies here.
-- c. (5 points) Compare the representation of the relationships "drives" and "operates" in your schema, and explain why they are different.
-- The relationships "drives" and "operates" are different because drives has a many to many relationship while operates has a many to one relationship according to the
-- diagram provided. In my schema, I created a mixed table to represent many to many relationship, "drives", in order to incorporate the relationship between
-- different nonprofessional drivers and the cars. However, I made the Truck entity to refer to the professional driver in order to represent one professional
-- driver operating, possibly, many trucks, satisfying many to one relationship.