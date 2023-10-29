CREATE DATABASE InsuranceCompany;

USE InsuranceCompany;

CREATE TABLE User
(
	Username VARCHAR (100) NOT NULL UNIQUE,
    Email VARCHAR (100) NOT NULL UNIQUE,
    Password VARCHAR (100) NOT NULL,
    Name VARCHAR (100) NOT NULL,
    Surname VARCHAR (100) NOT NULL
);

CREATE TABLE AdminUser
(
	UserId INT NOT NULL
);

CREATE TABLE Client
(
	UserId INT NOT NULL
);

CREATE TABLE InsuranceAgent
(
	PositionId INT NOT NULL,
    InsuranceAddressId INT NOT NULL,
    UserId INT NOT NULL
);
