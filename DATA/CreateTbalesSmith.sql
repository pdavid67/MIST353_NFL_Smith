--create a database fir NFL app
--use master;

--CREATE DATABASE MIST353_NFL_RDB_Smith

--DROP database NFL_RDB_Smith;

USE MIST353_NFL_RDB_Smith;

if OBJECT_ID('Team') IS NOT NULL
    DROP TABLE Team;

if OBJECT_ID('ConfrenceDivision') IS NOT NULL
    DROP TABLE ConfrenceDivision;



--create tables for first itteration

 CREATE TABLE Team (
    TeamID INT IDENTITY(1,1) CONSTRAINT PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(50) NOT NULL
);

CREATE TABLE ConfrenceDivision (
    ConfrenceDivisionID INT IDENTITY(1,1) 
        CONSTRAINT PK_ConfrenceDivision PRIMARY KEY,
    Confrence NVARCHAR(50) NOT NULL 
        CONSTRAINT CK_ConferenceNames CHECK (Confrence IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL 
        CONSTRAINT CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West'))
    CONSTRAINT UK_ConferenceDivision UNIQUE (Confrence, Division)
);



 