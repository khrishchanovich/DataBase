CREATE DATABASE IF NOT EXISTS InsuranceCompany;

USE InsuranceCompany;

DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS InsuranceAgent;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS InsuranceObject;
DROP TABLE IF EXISTS InsuranceType;
DROP TABLE IF EXISTS InsuranceOffice;
DROP TABLE IF EXISTS Journal;
DROP TABLE IF EXISTS Conract;

CREATE TABLE User
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Username VARCHAR (50) NOT NULL,
    Email VARCHAR (50) NOT NULL,
    Password VARCHAR (50) NOT NULL,
    Name VARCHAR (50) NOT NULL,
    Surname VARCHAR (50) NOT NULL,
    Status ENUM('Admin', 'Agent', 'Client') DEFAULT 'Client',
    
    UNIQUE(Username, Email),
    CONSTRAINT min_password_length CHECK (char_length(Password) >= 8)
);

CREATE TABLE Admin
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	UserId INT UNIQUE,
    
    CONSTRAINT admin_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE
);

CREATE TABLE Client
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	UserId INT UNIQUE,
    
	CONSTRAINT client_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE
);

CREATE TABLE Post
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR (50) NOT NULL UNIQUE,
    Description TEXT NOT NULL
);

CREATE TABLE InsuranceOffice
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Name VARCHAR (50) NOT NULL,
    Address VARCHAR (50) NOT NULL,
    PhoneNumber VARCHAR (12) NOT NULL,
    
    UNIQUE(Name, Address, PhoneNumber),
    
    CONSTRAINT insurance_address_uq UNIQUE(Name, Address, PhoneNumber),
    CONSTRAINT check_length_phone_number CHECK (char_length(PhoneNumber) >= 12)
);

CREATE TABLE InsuranceAgent
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	PostId INT,
    InsuranceOfficeId INT,
    UserId INT UNIQUE,
    
	CONSTRAINT agent_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE,
    CONSTRAINT agent_post_fk FOREIGN KEY (PostId) REFERENCES Post(Id) ON DELETE SET NULL,
    CONSTRAINT agent_office_fk FOREIGN KEY (InsuranceOfficeId) REFERENCES InsuranceOffice(Id) ON DELETE SET NULL 
);

CREATE TABLE Feedback
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Rating INT NOT NULL,
    Feedback TEXT,
    ClientId INT,
    
    CONSTRAINT user_rating CHECK(Rating >= 1 AND Rating <= 5),
    
    CONSTRAINT feedback_client_fk FOREIGN KEY (ClientId) REFERENCES Client(Id) ON DELETE SET NULL
);

CREATE TABLE Category
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR (50) NOT NULL UNIQUE,
    Description TEXT NOT NULL
);

CREATE TABLE InsuranceObject
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR (50) NOT NULL UNIQUE,
    Description TEXT NOT NULL
);

CREATE TABLE InsuranceType
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR (50) NOT NULL UNIQUE,
    Description TEXT NOT NULL,
    Rate DECIMAL(2,2) NOT NULL,
    CategoryId INT NOT NULL,
    InsuranceObjectId INT,
    
    CONSTRAINT type_category_fk FOREIGN KEY (CategoryId) REFERENCES Category(Id) ON DELETE CASCADE,
    CONSTRAINT type_object_fk FOREIGN KEY (InsuranceObjectId) REFERENCES InsuranceObject(Id) ON DELETE SET NULL
);

CREATE TABLE Journal
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	InsuranceAgentId INT,
    ClientId INT NOT NULL,
    InsuranceTypeId INT NOT NULL,
    InsuranceObjectId INT NOT NULL,
    Description TEXT NOT NULL,
    TimeCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsApproved BOOL DEFAULT 0,
    
    CONSTRAINT journal_agent_fk FOREIGN KEY (InsuranceAgentId) REFERENCES InsuranceAgent(Id) ON DELETE SET NULL,
    CONSTRAINT journal_client_fk FOREIGN KEY (ClientId) REFERENCES Client(Id) ON DELETE CASCADE,
    CONSTRAINT journal_type_fk FOREIGN KEY (InsuranceTypeId) REFERENCES InsuranceType(Id) ON DELETE CASCADE,
    CONSTRAINT journal_object_fk FOREIGN KEY (InsuranceObjectId) REFERENCES InsuranceObject(Id) ON DELETE CASCADE
);

CREATE TABLE Contract
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
	InitialPayment DECIMAL(5,2) NOT NULL CHECK (InitialPayment >= 10),
    TimeCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
    JournalId INT,
    
    CONSTRAINT contract_journal_fk FOREIGN KEY (JournalId) REFERENCES Journal(Id) ON DELETE SET NULL
);

CREATE INDEX idx_client_user ON Client (UserId);
CREATE INDEX idx_agent_user ON InsuranceAgent (UserId);
CREATE INDEX idx_insurance_type_category ON InsuranceType (CategoryId);
CREATE INDEX idx_insurance_type_object ON InsuranceType (InsuranceObjectId);
CREATE INDEX idx_journal_agent ON Journal (InsuranceAgentId);
CREATE INDEX idx_journal_client ON Journal (ClientId);
CREATE INDEX idx_journal_type ON Journal (InsuranceTypeId);
CREATE INDEX idx_journal_object ON Journal (InsuranceObjectId);
